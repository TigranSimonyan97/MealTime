//
//  RestoListViewController.swift
//  MealTime
//
//  Created by Tiko on 10/27/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import CoreData

class RestoListViewController: UITableViewController
{
    
    //Properties
    var restaurantList: [Restaurant] = []
    var restaurant: Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurnts"
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        
        getRestaurants()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRestaurants()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestoDetail"{
            let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurant
        }
    }
    
    //Get restaurants data from DB
    func getRestaurants() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        do{
            restaurantList = try context.fetch(request)
        }catch{
            print(error)
        }

    }
    
    //Unwind Segue
    
    @IBAction func backToHomePage(segue: UIStoryboardSegue){
    
    }
}

extension RestoListViewController
{
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(restaurantList.count)
        return restaurantList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / (320/230)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.restaurant = restaurantList[indexPath.row]
        self.performSegue(withIdentifier: "showRestoDetail", sender: self)
        print("Table View Cell")
        print(restaurant)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoLIstItemCell", for: indexPath) as! RestoListItemCell
        
        cell.restoNameLbl.text = self.restaurantList[indexPath.row].name
        cell.restoLocationLbl.text = self.restaurantList[indexPath.row].location
        cell.restoTypeLbl.text = self.restaurantList[indexPath.row].type
        cell.restoPhotoImage.image = UIImage(data: (self.restaurantList[indexPath.row].image as Data?)!)
        
        return cell
    }

}
