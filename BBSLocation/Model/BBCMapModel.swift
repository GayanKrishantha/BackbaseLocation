//
//  BBCMapModel.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCMapModel {
    
    var lon: Double? = 0.0
    var lat: Double? = 0.0
    
    init(dictionary : [String:Any]) {
        self.lon = dictionary ["lon"] as? Double
        self.lat = dictionary ["lat"] as? Double
    }
}
