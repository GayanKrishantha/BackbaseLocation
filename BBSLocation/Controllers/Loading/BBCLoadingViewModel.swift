//
//  BBCLoadingViewModel.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

class BBCLoadingViewModel {
    
    var imageData = [String]()
    
    func retriveImageData() -> [String] {
        imageData = ["home.png", "map_standers.png", "map_em1.png", "map_em2.png", "map_em3.png", "map_em4.png", "map_em5.png", "city_search.png", "search.png", "no_results.png", "name_searxch.png", "pull_to_refresh.png"]
        
        return imageData
    }
    
}
