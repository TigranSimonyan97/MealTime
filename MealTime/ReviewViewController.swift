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
    var restaurantImageName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set images for background image and restaurant image
        backgroundImage.image = UIImage(named: restaurantImageName)
        restaurantPhotoImageView.image = UIImage(named:restaurantImageName)
        
        
        //Prepearing for animation
        containerView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Appearing Animation
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
        
        
//        //Spring Animation
//        UIView.animate(withDuration: 0.3, delay: 0.0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {self.containerView.transform = CGAffineTransform.identity}, completion: nil)
        
    }
    
    

}
