//
//  BBCCityCell.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import UIKit

class BBCCityCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayCity(citty:BBCCityModel) {
        let cityName = citty.name
        let countryName = citty.country
        let address = cityName!+", "+countryName!
        
        nameLabel.text = address
    }

}
