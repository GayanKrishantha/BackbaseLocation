//
//  BBCConstants.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import Foundation

public struct BBCConstants {
    
    struct Messages {
        
        static let WELCOME_MESSAGE = "Welcome BBSLocation"
    }
    
    struct Colors {
        
        static let APP_BACKGROUND_COLOR = "EFF1F5"
        static let PROGRESSVIEW_UNFILLED_COLOR = "E1E2E4"
        static let PROGRESSVIEW_RED_COLOR = "FA2A1C"
        static let PROGRESSVIEW_GREEN_COLOR = "26AB5E"
        static let CIRCULE_BLUE_COLOR = "1685DF"
        static let CELL_HEADER_COMPAIR_COLOR = "B6B7B8"
    }
    
    struct Tags {
        
        static let STANDERS_BUTTON_TAG = 100
        static let SATALITE_BUTTON_TAG = 101
        static let HYBRID_BUTTON_TAG = 102
    }
    
    struct Charector {
        
        static let SEARCHBAR_LIMIT = 35

    }
    
    struct JsonReferenceType {
        
        static let CITY = "cities"
        static let XCT_ORIGINAL = "test_cities_original"
        static let XCT_SORTED = "test_cities_sorted"
        static let XCT_UNSORTED = "test_cities_unsorted"
    }
    
    struct CustomErrorCodes {
        
        static let NO_INTRNET = "No internet connection available!"
        static let ONLINE_STATUS = "Connection error!"
        static let DATEFORMATTER_DATE_TIME = "yyyy-MM-dd 'at' HH:mm"
        static let DATEFORMATTER_PREFIX = "Last update: "
        static let NO_DATA_TITLE = "No data!"
        static let NO_DATA_AVAILABLE = "No data available"
        static let LOCATION_SERVICE = "Location service!"
        static let LOCATION_SERVICE_DEFINETION = "Please check your location service"
        static let ALERT_SETTINGS_BUTTON = "Settings"
        static let ALERT_SETTINGS_CANCEL = "Cancel"
        static let ALERT_DONE = "Done"
        static let ALERT_OK = "OK"
        static let ALERT_SETTINGS = "Settings"
        static let ALERT_YES = "Yes"
        static let ALERT_NO = "No"
        static let ALERT_DELETE = "Delete"
        static let ALERT_CANCEL = "Cancel"
        static let ALERT_EDIT = "Edit"
    }
}

