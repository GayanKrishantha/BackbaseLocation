//
//  BBCCityViewModel.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCCityViewModel {
    
    var data = [BBCCityModel]()
    var searchData = [BBCCityModel]()
    var isCandidateSearch: Bool? = false
    
    init(isCandidateSearch: Bool? = false) {
        self.isCandidateSearch = isCandidateSearch
    }
    
    //Fetch cities
    func fetchLocation(completion:@escaping(_ status: Bool)->()) {
        self.data.removeAll()
        self.searchData.removeAll()
        
        BBCDataManager.sharedInstance.fetchLocation(jsonType: BBCConstants.JsonReferenceType.CITY) { (status, resource) in
            if status {
                guard let resource = resource else {
                    return completion(false)
                }
                
                /*
                 Add resources array for (from json file)
                 to the data array for the view controller precess
                 */
                self.data.append(contentsOf: resource)
                /*
                 Keep the orginal data
                 */
                self.searchData.append(contentsOf: self.data)
                
                return completion(true)
                
            } else {
                return completion(false)
            }
        }
    }
    
    /*
     Sort funtion has inplemented here
     */
    func sortByName(searchString:String, completion:@escaping() -> ()) {
        //Ermove element befor the search
        self.searchData.removeAll()
        
        DispatchQueue.global().async {
            let result = self.data.filter {($0.name?.lowercased().hasPrefix(searchString))! }
            DispatchQueue.main.sync {
                self.searchData = result
                completion()
            }
        }
    }
}
