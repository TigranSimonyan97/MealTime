//
//  RestaurantDetailViewController.swift
//  MealTime
//
//  Created by Tiko on 10/28/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class RestaurantDetailViewController: UIViewController {
    
    
    //UI Elements
    @IBOutlet weak var restoPhotoImg: UIImageView!
    @IBOutlet weak var restoInfoTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //Properties
    var restaurant: RestaurantModel!
    
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = restaurant.name
        self.navigationController?.navigationBar.tintColor = UIColor.black
        restoPhotoImg.image = UIImage(named: restaurant.image)
        
        
        
        restoInfoTableView.estimatedRowHeight = 36.0
        restoInfoTableView.rowHeight = UITableViewAutomaticDimension
        
        mapView.mapType = .standard
        
        //Set location
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(restaurant.location, completionHandler: {placemarks,error in
//            if error != nil{
//                let alert = UIAlertController(title: "Missing Location", message: "Sorry,but we can`t find restaurant location :(", preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//                print(error.debugDescription)
//            }else{
//                print("We are happy!!!")
//            }
//        })
        
        
        
        centerMapOnLocation(location: initialLocation)
        
        
        //Add tap gesture recognizer for MapView
        let mapViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(mapViewTapGesture)
        
        
        
//        //Get restaurant location coordinates
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: 25.432113, longitude: 17.226563)
//        geoCoder.reverseGeocodeLocation(location, completionHandler: {placemarks,error in if error != nil {
//            print("Make Error")
//            print(error.debugDescription)
//            return
//            }
//            if let placemarks = placemarks{
//                let placemark = placemarks[0]
//                
//                print("Make error \(placemark.location)")
//                
//                let annotation = MKPointAnnotation()
//                
//                
//                
//                if let location = placemark.location{
//                    //Set Annotation
//                    annotation.coordinate = location.coordinate
//                    self.mapView.addAnnotation(annotation)
//                    
//                    //Set zoom level
//                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 2500, 2500)
//                    self.mapView.setRegion(region, animated: true)
//                }
//            }
//            
//        })
//        
        
//        geoCoder.geocodeAddressString("Parliament Square, Westminster, St Margaret Street", completionHandler: {placemarks,error in if error != nil {
//            print("Make Error")
//            print(error.debugDescription)
//            return
//            }
//            if let placemarks = placemarks{
//                let placemark = placemarks[0]
//                
//                print("Make error \(placemark.location)")
//                
//                let annotation = MKPointAnnotation()
//                
//                
//                
//                if let location = placemark.location{
//                    //Set Annotation
//                    annotation.coordinate = location.coordinate
//                    self.mapView.addAnnotation(annotation)
//                    
//                    //Set zoom level
//                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
//                    self.mapView.setRegion(region, animated: false)
//                }
//            }
//            
//        })
    }
    
    
    func   centerMapOnLocation(location:CLLocation){
        //Add Radius
        let coordinateRadius = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRadius, animated: true)
        
        //Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    //Gestures handlers
    func showMap(){
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    //Unwind segue
    @IBAction func close(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue){
        
        restaurant.isVisited = true
        
        if let rating = segue.identifier{
            switch rating {
            case "great":
                restaurant.rating = "Absolutely love it! Must try."
            case "good":
                restaurant.rating = "Pretty good."
            case "dislike":
                restaurant.rating = "I don`t like it."
            default:
                break
            }
        }
        print(restaurant.rating)
        restoInfoTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier {
            case "showReview":
                let destinationViewController = segue.destination as! ReviewViewController
                destinationViewController.restaurantImageName = restaurant.image
            case "showMap":
                let destinationVIewController = segue.destination as! MapViewController
                destinationVIewController.location = initialLocation
                destinationVIewController.restaurant = restaurant
            default:
                break
            }
        }
    }
}

extension RestaurantDetailViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailCell", for: indexPath) as! RestaurantDetailCell
        
        switch indexPath.row {
        case 0:
            cell.nameLbl.text = "Name"
            cell.valueLbl.text = restaurant.name
        case 1:
            cell.nameLbl.text = "Type"
            cell.valueLbl.text = restaurant.type
        case 2:
            cell.nameLbl.text = "Location"
            cell.valueLbl.text = restaurant.location
        case 3:
            cell.nameLbl.text = "Phone"
            cell.valueLbl.text = restaurant.phone
        case 4:
            cell.nameLbl.text = "Been here"
            cell.valueLbl.text = restaurant.isVisited ? "Yes,I`ve been here before, \(restaurant.rating)" :"No"
        default: break
        }
        
        return cell
    }
}
