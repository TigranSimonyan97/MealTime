//
//  RestaurantDetailViewController.swift
//  MealTime
//
//  Created by Tiko on 10/28/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import AlamofireImage


class RestaurantDetailViewController: UIViewController{
    
    
    //UI Elements
    @IBOutlet weak var restoPhotoImg: UIImageView!
    @IBOutlet weak var restoInfoTableView: UITableView!
    
    
    //Properties
    var restaurant: RestaurantModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = restaurant.name
        self.navigationController?.navigationBar.tintColor = UIColor.black

//        
//        restoInfoTableView.delegate = self
//        restoInfoTableView.dataSource = self
        
        let imageURL = restaurant.mainImgLink
        let url = URL(string: imageURL)
        
        self.restoPhotoImg.image = nil
        self.restoPhotoImg.af_setImage(withURL: url!)
        
        
    }
}

extension RestaurantDetailViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailCell", for: indexPath) as! RestaurantDetailCell
        
        switch indexPath.row {
        case 0:
            cell.nameLbl.text = "Name"
            cell.valueLbl.text = restaurant.name
        case 1:
            cell.nameLbl.text = "Location"
            cell.valueLbl.text = restaurant.address
        case 2:
            cell.nameLbl.text = "Is Open"
            if restaurant.isOpen{
                cell.valueLbl.text = "Բաց Է :)"
            }else{
                cell.valueLbl.text = "Փակ Է :("
            }
        default: break
        }
        
        return cell
    }
}
