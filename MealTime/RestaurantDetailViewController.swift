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
import FirebaseStorage


class RestaurantDetailViewController: UIViewController
{
    //UI Elements
    @IBOutlet weak var restoPhotoImg: UIImageView!{
        didSet{
            spinner?.stopAnimating()
        }
    }
    @IBOutlet weak var restoInfoTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Properties
//    var restaurant: Restaurant!
    
    
    var restaurantFIR: RestaurantModel!
    
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = restaurant.name
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        restoPhotoImg.image = UIImage(data: (restaurant.image as Data?)!)
        
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(self.restaurantFIR.name)image.png")
            
        imageRef.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error.debugDescription)
            }else {
                if let imageData = data {
                    self.restoPhotoImg.image = UIImage(data: imageData)
                }
            }
        }
                
        restoInfoTableView.estimatedRowHeight = 36.0
        restoInfoTableView.rowHeight = UITableViewAutomaticDimension
        
        
        mapView.mapType = .standard
        
        //Set location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("30 Abovyan str., Yerevan", completionHandler: {placemarks,error in
            if error != nil{
                let alert = UIAlertController(title: "Missing Location", message: "Sorry,but we can`t find restaurant location :(", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                print(error.debugDescription)
            }else{
                
                if let placemarks = placemarks{
                    let placemark = placemarks[0]
                    
                    print("Make error \(placemark.location)")
                    
                    let annotation = MKPointAnnotation()
                    
                    
                    
                    if let location = placemark.location{
                        //Set Annotation
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        
                        //Set zoom level
                        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 2500, 2500)
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
        })
        
        //Add tap gesture recognizer for MapView
        let mapViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(mapViewTapGesture)
    }
    
    
    func countRestaurantRating(rating: [String : Int]) -> Double
    {

        var ratingCount = 0.0
        var ratingSum = 0.0
        
        for (key, value) in rating {
            let stars = starCount(key)
            ratingSum = ratingSum + stars * Double(value)
            ratingCount = ratingCount + Double(value)
        }
        
        return ratingSum / ratingCount
    }
    
    func starCount(_ key: String) -> Double {
        var starCount: Double!
        switch key {
        case "1star":
            starCount = 1.0
        case "3star":
            starCount = 3.0
        case "5star":
            starCount = 5.0
        default:
            break
        }
        return starCount
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
        
//        restaurant.isVisited = true
//        
//        if let rating = segue.identifier{
//            switch rating {
//            case "great":
//                restaurant.rating = "Absolutely love it! Must try."
//            case "good":
//                restaurant.rating = "Pretty good."
//            case "dislike":
//                restaurant.rating = "I don`t like it."
//            default:
//                break
//            }
//        }
//        print(restaurant.rating)
//        restoInfoTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier {
            case "showReview":
                let destinationViewController = segue.destination as! ReviewViewController
//                destinationViewController.restaurantImageName = restaurant.image as Data?
            case "showMap":
                let destinationVIewController = segue.destination as! MapViewController
                destinationVIewController.location = initialLocation
//                destinationVIewController.restaurant = restaurant
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
            cell.valueLbl.text = restaurantFIR.name
        case 1:
            cell.nameLbl.text = "Type"
            cell.valueLbl.text = restaurantFIR.type
        case 2:
            cell.nameLbl.text = "Location"
            cell.valueLbl.text = restaurantFIR.location
        case 3:
            cell.nameLbl.text = "Phone"
            cell.valueLbl.text = restaurantFIR.phone
        case 4:
            cell.nameLbl.text = "Rating"
            cell.valueLbl.text = "\(countRestaurantRating(rating: restaurantFIR.rating))/5.0" //restaurant.isVisited ? "Yes,I`ve been here before, \(restaurant.rating)" :"No"
        default: break
        }
        
        return cell
    }
}
