//
//  MapViewController.swift
//  MealTime
//
//  Created by Tiko on 11/5/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate {

    //UI Elements
    @IBOutlet weak var mapView: MKMapView!
    
    //Properties
    var restaurantFIR: RestaurantModel!
    var location: CLLocation!
    let radius: CLLocationDistance = 2500
    var restaurantImageDataForMApAnnotation: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Map"
        
        mapView.delegate = self
        
        //Set location
        centerMapOnLocation(location: location)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let restaurantImageForAnnotation = UIImageView(frame: CGRect.init(x: 0.0, y: 0.0, width: 53, height: 53))
        restaurantImageForAnnotation.image = restaurantImageDataForMApAnnotation
        annotationView?.leftCalloutAccessoryView = restaurantImageForAnnotation
        
        return annotationView
    }
    
    func centerMapOnLocation(location: CLLocation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = restaurantFIR.name
        annotation.subtitle = restaurantFIR.type
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
}
