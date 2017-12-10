//
//  AddRestaurantTableViewController.swift
//  MealTime
//
//  Created by Tiko on 11/5/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import CoreData
import FirebaseStorage

class AddRestaurantTableViewController: UITableViewController
{
    
    //UI Elements
    @IBOutlet weak var chosenPhotoImageView: UIImageView!
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var restaurantTypeTextField: UITextField!
    @IBOutlet weak var restaurantLocationTextField: UITextField!
    @IBOutlet weak var restaurantPhoneTextField: UITextField!
    
    @IBOutlet weak var yesButton: UIButton!
    
    //Properties
    var isVisited: Bool = false
    var restaurantRating: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        
        let handler = UITapGestureRecognizer(target: self, action: #selector(imagePickerCellTouchUP(_:)))
        chosenPhotoImageView.addGestureRecognizer(handler)
        
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .photoLibrary
//                
//                present(imagePicker, animated: true, completion: nil)
//            }
//        }
//    }
//    
    
    
    //MARK: - Actions
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue)
    {
        restaurantRating = segue.identifier
    }
    
    @IBAction func imagePickerCellTouchUP(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonTouchUp(_ sender: UIBarButtonItem){
        if restaurantNameTextField.text != "" ,
            restaurantTypeTextField.text != "" ,
            restaurantLocationTextField.text != "",
            restaurantRating != nil,
            restaurantPhoneTextField.text != "" {
            
            //Using CoreData
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            let context = appDelegate?.persistentContainer.viewContext
//            
//            let restaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: context!) as! Restaurant
//            restaurant.name = restaurantNameTextField.text
//            restaurant.type = restaurantTypeTextField.text
//            restaurant.location = restaurantLocationTextField.text
//            restaurant.isVisited = isVisited
//            restaurant.rating = String(describing: restaurantRating)
            
//            if let restaurantImage = chosenPhotoImageView.image {
//                if let imageData = UIImagePNGRepresentation(restaurantImage) {
//                    restaurant.image = NSData(data: imageData)
//                }
//            }
//            
//            appDelegate?.saveContext()
            
            
            
            //Using FireBaseDatabase
            let restaurantName = restaurantNameTextField.text!
            let restaurantType = restaurantTypeTextField.text!
            let restaurantLocaton = restaurantLocationTextField.text!
            let restaurantPhone = restaurantPhoneTextField.text!
            
            var rating: [String : Int] = [:]
            if let restoRating = restaurantRating {
                switch restoRating {
                case "great":
                    rating = ["1star" : 0, "3star" : 0, "5star" : 1]
                case "good":
                    rating = ["1star" : 0, "3star" : 1, "5star" : 0]
                case "dislike":
                    rating = ["1star" : 1, "3star" : 0, "5star" : 0]
                default:
                    break
                }
            }
            
            let restaurant = RestaurantModel(name: restaurantName, type: restaurantType, location: restaurantLocaton, phone: restaurantPhone, rating: rating)
            
            DataService.instance.saveRestaurant(restaurantModel: restaurant)
            
            
            //Upload restaurant image to FirebaseStorage
            let  storageRef = Storage.storage().reference().child("\(restaurantName)image.png")
            
            if let restaurantImage = chosenPhotoImageView.image {
                if let uploadedData = UIImagePNGRepresentation(restaurantImage) {
                    storageRef.putData(uploadedData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        print(metadata)
                    })
                }
            }

            
            
            //Clear TextFields values
            restaurantNameTextField.text = nil
            restaurantLocationTextField.text = nil
            restaurantTypeTextField.text = nil
            restaurantPhoneTextField.text = nil
            
            dismiss(animated: true, completion: nil)
         
        }else {
            let alert = UIAlertController(title: "Opps", message: "We can`t proceed ,because one of the field is blank.PLease note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func addRestaurantImageConstraints(){
        //Adding Constriants
        let leadingConstriant = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .leading, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstriant.isActive = true
        
        let trailingConstriant = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .trailing, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstriant.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .top, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .bottom, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
    }
}

extension AddRestaurantTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chosenPhotoImageView.image = selectedImage
            chosenPhotoImageView.contentMode = .scaleAspectFill
            chosenPhotoImageView.clipsToBounds = true
        }
        addRestaurantImageConstraints()
        
        dismiss(animated: true, completion: nil)
    }

}


