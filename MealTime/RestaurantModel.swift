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
    var image: String
    var isVisited: Bool
    var phone: String
    var rating: String = ""
    
    init(name: String, type: String, location: String, phone: String, image: String, isVisited: Bool){
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
        self.phone = phone
    }
}
