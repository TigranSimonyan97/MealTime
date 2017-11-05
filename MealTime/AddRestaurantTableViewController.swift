//
//  AddRestaurantTableViewController.swift
//  MealTime
//
//  Created by Tiko on 11/5/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit

class AddRestaurantTableViewController: UITableViewController
{
    
    //UI Elements
    @IBOutlet weak var chosenPhotoImageView: UIImageView!
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var restaurantTypeTextField: UITextField!
    @IBOutlet weak var restaurantLocationTextField: UITextField!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    //Properties
    var isVisited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationController?.navigationBar.backgroundColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:  Actions
    
    @IBAction func isVisitedButtonTouchUp(sender: UIButton) {
        
        switch sender {
        case yesButton:
            isVisited = true
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.lightGray
        case noButton:
            isVisited = false
            yesButton.backgroundColor = UIColor.lightGray
            noButton.backgroundColor = UIColor.red
        default:
            break
        }
    }
    
    @IBAction func saveButtonTouchUp(_ sender: UIBarButtonItem){
        if restaurantNameTextField.text != "" ,
             restaurantTypeTextField.text != "" , restaurantLocationTextField.text != "" {
            print("Name is:\(restaurantNameTextField.text),Type is: \(restaurantTypeTextField.text), Location is: \(restaurantLocationTextField.text)")
        }else {
            let alert = UIAlertController(title: "Opps", message: "We can`t proceed ,because one of the field is blank.PLease note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
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
        
        //Adding Constriants
        let leadingConstriant = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .leading, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstriant.isActive = true
        
        let trailingConstriant = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .trailing, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstriant.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .top, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: chosenPhotoImageView, attribute: .bottom, relatedBy: .equal, toItem: chosenPhotoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }

}
