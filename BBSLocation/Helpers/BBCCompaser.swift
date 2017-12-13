//
//  BBCCompaser.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/14/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class BBCCompaser: MKMapView {
    
    
    private var compassTopValue: CGFloat = 30
    private var compassLeftValue: CGFloat = 15
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let compassView = self.subviews.filter({ $0.isMember(of: NSClassFromString("MKCompassView")!) }).first {
            compassView.frame = CGRect(x: 15, y: 30, width:36 , height: 36)
            ////CGRectMake(15, 30, 36, 36)
        }
    }
    
    
    func setCompassPosition(left: CGFloat, top: CGFloat, animated: Bool) {
        compassTopValue = top
        compassLeftValue = left
        setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.layoutIfNeeded()
        }
    }
}

