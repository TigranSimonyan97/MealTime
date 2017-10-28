//
//  RestoListViewController.swift
//  MealTime
//
//  Created by Tiko on 10/27/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RestoListViewController: UITableViewController {
    
    //Server URL
    let url = "http://360buking.azurewebsites.net/api/Data/AM/Restaurants/GetAll"
    
    //Properties
    var restaurants: [RestaurantModel] = []
    var restaurant: RestaurantModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurnts"
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        
        getRestaurants()
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / (320/230)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.restaurant = restaurants[indexPath.row]
        self.performSegue(withIdentifier: "showRestoDetail", sender: self)
        print("Table View Cell")
        print(restaurant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "showRestoDetail"{
            let destinationController = segue.destination as! RestaurantDetailViewController
                
                destinationController.restaurant = self.restaurant
            print("Works")
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoLIstItemCell", for: indexPath) as! RestoListItemCell
        
        cell.restoNameLbl.text = self.restaurants[indexPath.row].name
        cell.restoLocationLbl.text = self.restaurants[indexPath.row].address
        
        if self.restaurants[indexPath.row].isOpen{
            cell.restoTypeLbl.text = "Open"
        }else{
            cell.restoTypeLbl.text = "Closed"
        }
        
        //Set Restaurant image
        let imageURL = self.restaurants[indexPath.row].mainImgLink
        let url = URL(string: imageURL)
        
        cell.restoPhotoImage.image = nil
        cell.restoPhotoImage.af_setImage(withURL: url!)
        
        return cell
    }
    
    //Get restaurants from server
    func getRestaurants(){
        Alamofire.request(url).responseJSON{response in
            
            let data = response.result.value as! [[String : Any]]
            
            self.restaurants = data.map{RestaurantModel(json: $0)}
            self.tableView.reloadData()
        }
    }
    
    
}
