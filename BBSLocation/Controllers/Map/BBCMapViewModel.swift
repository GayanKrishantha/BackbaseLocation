//
//  BBCMapViewModel.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCMapViewModel {
    
    var addressInfo:String = ""
    var city: BBCCityModel? = nil
    
    init(city: BBCCityModel) {
        self.city = city
    }
    
    func processTheAddress(localitys:String, postalCodes:String, administrativeAreas:String, countrys:String)-> String{
        var address:String = ""
        
        if (localitys.isEmpty) {
            address = (postalCodes)+" "+(administrativeAreas)+" "+(countrys)
        }else if (postalCodes.isEmpty) {
            address = (localitys)+" "+(administrativeAreas)+" "+(countrys)
        }else if (administrativeAreas.isEmpty) {
            address = (localitys)+" "+(postalCodes)+" "+(countrys)
        }else {
            address = (localitys)+" "+(postalCodes)+" "+(administrativeAreas)+" "+(countrys)
        }
        
        return address
    }
    
}
