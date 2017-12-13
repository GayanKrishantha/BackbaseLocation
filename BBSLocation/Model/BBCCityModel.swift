//
//  BBCCityModel.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCCityModel {
    
    var country: String? = ""
    var name: String? = ""
    var _id: Int? = 0
    var location: BBCMapModel?
    
    init(dic: Dictionary<String, Any>) {
        
        self.country = dic ["country"] as? String
        self.name = dic ["name"] as? String
        self._id = dic ["_id"] as? Int
        self.country = dic ["country"] as? String
        self.location = BBCMapModel(dictionary : dic ["coord"] as! [String : Any])
    }
}
