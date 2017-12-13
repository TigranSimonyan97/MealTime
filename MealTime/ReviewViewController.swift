//
//  ReviewViewController.swift
//  MealTime
//
//  Created by Tiko on 11/4/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    //UI Elements
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var restaurantPhotoImageView: UIImageView!
    //Properties
    //var restaurantImageName: Data!
    var segueFromController: String!
    var rating: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set images for background image and restaurant image
        backgroundImage.image = UIImage(named: "cafedeadend")
        restaurantPhotoImageView.image = UIImage(named: "cafedeadend")
        
        
        //Prepearing for animation
        containerView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        
        
        print("segueFromController: \(segueFromController)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Appearing Animation
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
        
//        //Spring Animation
//        UIView.animate(withDuration: 0.3, delay: 0.0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {self.containerView.transform = CGAffineTransform.identity}, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let identifier = segue.identifier!
        
        
        switch identifier {
        case "rateFromDetailWithSegue":
            let destinationController = segue.destination as! RestaurantDetailViewController
            destinationController.ratingFromReview = self.rating
        case "rateFromAddRestaurantWithSegue":
            let destinationController = segue.destination as! AddRestaurantTableViewController
            destinationController.ratingFromReview = self.rating
        default:
            break
        }
    }
    
    @IBAction func unwindSegue(sender:UIButton)
    {
        switch segueFromController {
        case "DetailController":
            performSegue(withIdentifier: "closeRatingFromDetailControllerWithSegue", sender: nil)
        case "AddRestaurantController":
            performSegue(withIdentifier: "closeRatingFromAddRestaurantControllerWithSegue", sender: nil)
        default:
            break
        }
    }
    
    @IBAction func rateRestaurant(sender: UIButton)
    {
        switch segueFromController {
        case "DetailController":
            rating = Double(sender.tag)
            performSegue(withIdentifier: "rateFromDetailWithSegue", sender: nil)
        case "AddRestaurantController":
            rating = Double(sender.tag)
            performSegue(withIdentifier: "rateFromAddRestaurantWithSegue", sender: nil)
        default:
            break
        }

    }

}
