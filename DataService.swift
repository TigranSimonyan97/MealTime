//
//  DataService.swift
//  MealTime
//
//  Created by Tiko on 12/8/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataService
{
    private static let _instance = DataService()
    
    
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference{
        return Database.database().reference()
    }
    
    func saveRestaurant(restaurantModel:RestaurantModel) {
        let restaurant: Dictionary<String, Any> = ["restaurantName" : restaurantModel.name,
                                                         "restaurantType" : restaurantModel.type,
                                                         "restaurantPhone" :restaurantModel.phone,
                                                         "restaurantLocation" : restaurantModel.location,
                                                         "restaurantRating" : restaurantModel.rating]
        
        mainRef.child("restaurant").childByAutoId().setValue(restaurant)
    }
    
    func getRestaurants() -> [RestaurantModel] {
        
        var restaurants = [RestaurantModel]()
        
        let storageRef = Database.database().reference().child("restaurant")
        storageRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let snapshotValue = snapshot.value as? [String : Any] {
                for (value) in snapshotValue.values {
                    if let json = value as? [String : Any]{
                        let restaurant = RestaurantModel(json: json)
                        restaurants.append(restaurant)
                    }
                }
            }
        }
        
        return restaurants
    }
    
    
}
