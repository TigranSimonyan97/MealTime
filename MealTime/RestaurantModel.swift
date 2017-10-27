//
//  RestaurantModel.swift
//  MealTime
//
//  Created by Tiko on 10/28/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import Foundation

struct RestaurantModel {
   
    
    var id: Int = 0
    var name: String
    var logoLink: String
    var mainImgLink:String
    var cost: String
    var city: String
    var address: String
    var isOpen24: Bool
    var openingTime: String?
    var closingTime: String?
    var additionalOpeningTime: String?
    var additionalClosingTime: String?
    var isOpen: Bool
    var ratedCount: Int
    var rating: Double
    
    init(json: [String : Any]) {
        id = json["id"] as? Int ?? 0
        name = json["name"] as? String ?? ""
        logoLink = json["logoLink"] as? String ?? ""
        mainImgLink = json["mainImgLink"] as? String ?? ""
        cost = json["cost"] as? String ?? ""
        city = json["city"] as? String ?? ""
        address = json["address"] as? String ?? ""
        isOpen24 = json["isOpen24"] as? Bool ?? false
        openingTime = json["openingTime"] as? String ?? nil
        closingTime = json["closingTime"] as? String ?? nil
        additionalOpeningTime = json["additionalOpeningTime"] as? String ?? nil
        additionalClosingTime = json["additionalClosingTime"] as? String ?? nil
        isOpen = json["isOpen"] as? Bool ?? false
        ratedCount = json["ratedCount"] as? Int ?? 0
        rating = json["rating"] as? Double ?? 0.0
        
    }
    
    
}
