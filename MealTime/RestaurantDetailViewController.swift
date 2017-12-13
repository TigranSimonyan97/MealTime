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
    @IBOutlet weak var restoPhotoImg: UIImageView!
    @IBOutlet weak var restoInfoTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var rateButton: UIButton!
    
    //Properties
//    var restaurant: Restaurant!
    var restaurantFIR: RestaurantModel!
    
    var restaurantRating: String?
    var ratingFromReview: Double? {
        didSet {
            updateRestaurantRating()
        }
    }
    
    var restaurantImageDataForMapAnnotation: UIImage?
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = restaurantFIR.name
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        restoPhotoImg.image = UIImage(data: (restaurant.image as Data?)!)
        
        restoInfoTableView.delegate = self
        restoInfoTableView.dataSource = self
        
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(self.restaurantFIR.name)image.png")
            
        imageRef.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error.debugDescription)
            }else {
                if let imageData = data {
                    self.restoPhotoImg.image = UIImage(data: imageData)
                    self.spinner.stopAnimating()
                    if let image = self.restoPhotoImg.image {
                        self.restaurantImageDataForMapAnnotation = image
                    }
                }
            }
        }
                
        restoInfoTableView.estimatedRowHeight = 36.0
        restoInfoTableView.rowHeight = UITableViewAutomaticDimension
        
        
        mapView.mapType = .standard
        
        //Set location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurantFIR.location, completionHandler: {placemarks,error in
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
                        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500)
                        self.mapView.setRegion(region, animated: true)
                        
                        self.initialLocation = location
                    }
                }
            }
        })
        
        //Add tap gesture recognizer for MapView
        let mapViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(mapViewTapGesture)
        
        
        if (UserDefaults.standard.bool(forKey: "UserRateRestaurant_\(restaurantFIR.id)")) {
            setRateButtonState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let rat = ratingFromReview {
            print("rat is from detail : \(rat)")
        }
    }
    
    func setRateButtonState()
    {
        rateButton.setImage(UIImage(named: "cross"), for: .normal)
        rateButton.isUserInteractionEnabled = false
    }
    
    func updateRestaurantRating()
    {
        switch ratingFromReview! {
        case 5.0:
            restaurantFIR.rating["5star"] = restaurantFIR.rating["5star"]! + 1
        case 3.0:
            restaurantFIR.rating["3star"] = restaurantFIR.rating["3star"]! + 1
        case 1.0:
            restaurantFIR.rating["1star"] = restaurantFIR.rating["1star"]! + 1
        default:
            break
        }
        DataService.instance.updateRating(restaurantModel: restaurantFIR)
    }
    
    func countRestaurantRating(rating: [String : Int]) -> (rating: Double,ratersCount: Int)
    {
        var ratingCount = 0.0
        var ratingSum = 0.0
        
        for (key, value) in rating {
            let stars = starCount(key)
            ratingSum = ratingSum + stars * Double(value)
            ratingCount = ratingCount + Double(value)
        }
        
        return (Double(round(10*(ratingSum / ratingCount))/10), Int(ratingCount))
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
    
    //Make Call
    func makeCall(number: String) {
        let phoneNumber = number.replacingOccurrences(of: " ", with: "")
        let url = URL(string: "tel://\(phoneNumber)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print("makeCall")
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
    @IBAction func closeRatingFromDetailController(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func rateButtonTapped(segue: UIStoryboardSegue)
    {
        restaurantRating = segue.identifier
        print("restaurantRating from detail \(restaurantRating)")
        UserDefaults.standard.set(true, forKey: "UserRateRestaurant_\(restaurantFIR.id)")
        restoInfoTableView.reloadData()
        setRateButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier {
            case "showRatingFromDetail":
                let destinationViewController = segue.destination as! ReviewViewController
                destinationViewController.segueFromController = "DetailController"
            case "showMap":
                let destinationVIewController = segue.destination as! MapViewController
                destinationVIewController.location = initialLocation
                destinationVIewController.restaurantFIR = restaurantFIR
            default:
                break
            }
        }
    }
}

extension RestaurantDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
            cell.valueLbl.text = "\(countRestaurantRating(rating: restaurantFIR.rating).rating)/5.0  Raters: \(countRestaurantRating(rating: restaurantFIR.rating).ratersCount)" //restaurant.isVisited ? "Yes,I`ve been here before, \(restaurant.rating)" :"No"
        default: break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 3 {
            makeCall(number: restaurantFIR.phone)
        }
        print("indexPathe.row is : \(indexPath.row)")
    }
}
