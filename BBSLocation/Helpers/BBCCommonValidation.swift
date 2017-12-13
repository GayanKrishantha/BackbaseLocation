//
//  BBCCommonValidation.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

import Foundation
import SystemConfiguration
import UIKit

class BBCCommonValidation  {
    
    // Get date and time format
    class func getCurrentDateAndTime(formatString: String, prefixText: String) -> String {//Last update :
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = formatString
        
        let result = formatter.string(from: date)
        let withStringFormat = result
        
        let refreshDataDict:String = prefixText + withStringFormat
        return refreshDataDict
    }
    
    // Generate random numbers as double
    class func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    // Generate random numbers as int
    class func randomIntNumbers(start: Int, to end: Int) -> Int {
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
    }
    
    //Generate random numbers
    class func RandomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        //print(Int(arc4random_uniform(UInt32((max - min) + 1))) + min)
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
    //Online checking
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}

