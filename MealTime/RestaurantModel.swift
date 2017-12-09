//
//  RestaurantModel.swift
//  MealTime
//
//  Created by Tiko on 10/28/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import Foundation

struct RestaurantModel
{
    var name: String
    var type: String
    var location: String
    var phone: String
    var rating: Double = 0.0
    
    init(json: [String : Any]) {
        self.name = json["restaurantName"] as? String ?? ""
        self.type = json["restauranttype"] as? String ?? ""
        self.location = json["restaurantLocation"] as? String ?? ""
        self.phone = json["restaurantPhone"] as? String ?? ""
        self.rating = json["restaurantRating"] as? Double ?? 0.0
    }
    
    init(name: String, type: String, location: String, phone: String,rating: Double) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.rating = rating
    }
}
