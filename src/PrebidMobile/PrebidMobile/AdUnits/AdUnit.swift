/*   Copyright 2018-2019 Prebid.org, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import ObjectiveC.runtime

@objcMembers public class AdUnit: NSObject, DispatcherDelegate {

    var prebidConfigId: String! = ""
    
    var adSizes = Array<CGSize> ()
    
    var identifier:String
    
    var dispatcher: Dispatcher?
    
    //This flag is set to check if the refresh needs to be made though the user has not invoked the fetch demand after initialization
    private var isInitialFetchDemandCallMade: Bool = false
    
    private var adServerObject:AnyObject?
    
    private var closure: (ResultCode) -> Void

    //notification flag set to check if the prebid response is received within the specified time
    var didReceiveResponse: Bool! = false

    //notification flag set to determine if delegate call needs to be made after timeout delegate is sent
    var timeOutSignalSent: Bool! = false

    init(configId: String, size: CGSize) {
        self.closure = {_ in return}
        prebidConfigId = configId
        adSizes.append(size)
        identifier = UUID.init().uuidString
        super.init()
    }

    dynamic public func fetchDemand(adObject: AnyObject, completion: @escaping(_ result: ResultCode) -> Void) {

        Utils.shared.removeHBKeywords(adObject: adObject)

        for size in adSizes {
            if (size.width < 0 || size.height < 0) {
                completion(ResultCode.prebidInvalidSize)
                return
            }
        }

        if (prebidConfigId.isEmpty || (prebidConfigId.trimmingCharacters(in: CharacterSet.whitespaces)).count == 0) {
            completion(ResultCode.prebidInvalidConfigId)
            return
        }
        if (Prebid.shared.prebidServerAccountId.isEmpty || (Prebid.shared.prebidServerAccountId.trimmingCharacters(in: CharacterSet.whitespaces)).count == 0) {
            completion(ResultCode.prebidInvalidAccountId)
            return
        }

        if !isInitialFetchDemandCallMade {
            isInitialFetchDemandCallMade = true
            startDispatcher()
        }

        didReceiveResponse = false
        timeOutSignalSent = false
        self.closure = completion
        adServerObject = adObject
        let manager: BidManager = BidManager(adUnit: self)

        manager.requestBidsForAdUnit { (bidResponse, resultCode) in
            self.didReceiveResponse = true
            if (bidResponse != nil) {
                if (!self.timeOutSignalSent) {
                    Utils.shared.validateAndAttachKeywords (adObject: adObject, bidResponse: bidResponse!)
                    completion(resultCode)
                }

            } else {
                if (!self.timeOutSignalSent) {
                    completion(resultCode)
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(.PB_Request_Timeout), execute: {
            if (!self.didReceiveResponse) {
                self.timeOutSignalSent = true
                completion(ResultCode.prebidDemandTimedOut)

            }
        })
    }

    /**
     * This method allows to set the auto refresh period for the demand
     *
     * - Parameter time: refresh time interval
     */
    public func setAutoRefreshMillis(time:Double) {
        
        stopDispatcher()
        
        guard time >= .PB_MIN_RefreshTime else {
            Log.error("auto refresh not set as the refresh time is less than to \(.PB_MIN_RefreshTime as Double) seconds")
            return
        }
        
        initDispatcher(refreshTime: time)
        
        if isInitialFetchDemandCallMade {
            startDispatcher();
        }
    }

    /**
     * This method stops the auto refresh of demand
     */
    public func stopAutoRefresh(){
        stopDispatcher()
    }

    func refreshDemand() {
        if (adServerObject != nil) {
            self.fetchDemand(adObject: adServerObject!, completion: self.closure)
        }

    }
    
    func initDispatcher(refreshTime: Double) {
        self.dispatcher = Dispatcher.init(withDelegate:self, autoRefreshMillies: refreshTime)
    }
    
    func startDispatcher() {
        guard let dispatcher = self.dispatcher else {
            Log.verbose("Dispatcher is nil")
            return
        }
        
        dispatcher.start()
    }
    
    func stopDispatcher() {
        guard let dispatcher = self.dispatcher else {
            Log.verbose("Dispatcher is nil")
            return
        }
        
        dispatcher.stop()
        self.dispatcher = nil
    }

}
