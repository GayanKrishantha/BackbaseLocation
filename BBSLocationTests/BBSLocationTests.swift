//
//  BBSLocationTests.swift
//  BBSLocationTests
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import XCTest
@testable import BBSLocation

struct BBCCityModel {
    
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

struct BBCMapModel {
    
    var lon: Double? = 0.0
    var lat: Double? = 0.0
    
    init(dictionary : [String:Any]) {
        self.lon = dictionary ["lon"] as? Double
        self.lat = dictionary ["lat"] as? Double
    }
}

class BBSLocationTests: XCTestCase {
    var viewModel: BBCCityViewModel = BBCCityViewModel()
    var dataArray = [BBCCityModel]()
    
    var realData = [BBCCityModel]()
    var unSortadData = [BBCCityModel]()
    var sortadData = [BBCCityModel]()
    
    override func setUp() {
        super.setUp()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testArrayIsUnSortes() {
        
        realData = jsonResponse(referenceType: "test_cities_original")
        unSortadData = jsonResponse(referenceType: "test_cities_sorted")
        
        XCTAssertEqual(realData.first?.name, unSortadData.first?.name, "the array has sorted properly")
        XCTAssertEqual(realData.last?.name, unSortadData.last?.name, "the array has sorted properly")
    }
}

extension BBSLocationTests {
    
    func jsonResponse(referenceType:String)-> [BBCCityModel] {
        dataArray.removeAll()
        if let path = Bundle.main.path(forResource: referenceType, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let data = jsonResult["data"] as? [Any] {
                    // do stuff
                    for club in data {
                        if let clubDictionary = club as? [String: Any] {
                            let obj = BBCCityModel(dic: clubDictionary)
                            dataArray.append(obj)
                        }
                    }
                }
            } catch {
                print("No json file exist")
            }
        }
        return dataArray
    }
}
