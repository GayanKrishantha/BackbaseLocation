//
//  BBCDataManager.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCDataManager {
    
    static let sharedInstance = BBCDataManager()
    
    //Get locations from the local json file
    func fetchLocation(completion:@escaping(_ status: Bool, _ location: [BBCCityModel]?)->()) {
        
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            
            do {
                
                //JSON data validation
                var datatArray = [BBCCityModel]()
                var tempArray = [BBCCityModel]()
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Any>,
                    let data = jsonResult["data"] as? [Any] {
                    
                    DispatchQueue.global().async {
                        for club in data {
                            if let clubDictionary = club as? [String: Any] {
                                let dd = BBCCityModel(dic: clubDictionary)
                                tempArray.append(dd)
                            }
                        }
                        
                        //Array sorting
                        tempArray.sort(by: { $0.name! < $1.name! })
                        
                        DispatchQueue.main.sync {
                            datatArray = tempArray
                           return completion(true, datatArray)
                        }
                    }
                }
            } catch {
                
                // handle error
                return completion(false, nil)
            }
        }
    }
}
