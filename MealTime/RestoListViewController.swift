//
//  RestoListViewController.swift
//  MealTime
//
//  Created by Tiko on 10/27/17.
//  Copyright © 2017 Tigranakert. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI

class RestoListViewController: UITableViewController
{
    
    var searchController: UISearchController!
    
    //Properties
    var restaurantList: [Restaurant] = []
    var restaurant: Restaurant!
    var restaurantListFromFirebase: [RestaurantModel] = []
    
    var searchResult: [Restaurant] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurnts"
        navigationController?.navigationBar.backgroundColor = UIColor.darkGray
        
        //Prepearing Search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
        //Get Data from Firebase Database
        
        getRestaurants()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRestaurantsFromFIRDB()
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
    
    //Get restaurant from Firebase Database
    func getRestaurantsFromFIRDB() {
        let databaseRef = Database.database().reference().child("restaurant")
        
        databaseRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let snapshotValue = snapshot.value as? [String : Any] {
                for (value) in snapshotValue.values {
                    if let json = value as? [String : Any]{
                        let restaurant = RestaurantModel(json: json)
                        self.restaurantListFromFirebase.append(restaurant)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func  filterContent(for searchText: String) {
        searchResult = restaurantList.filter({ (resraurant) -> Bool in
            print(restaurantList)
            if let name = restaurant.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
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
        return searchController.isActive ? searchResult.count : restaurantListFromFirebase.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / (320/230)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.restaurant = searchController.isActive ?  searchResult[indexPath.row] : restaurantList[indexPath.row]
        self.performSegue(withIdentifier: "showRestoDetail", sender: self)
        print("Table View Cell")
        print(restaurant)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let restaurants = searchController.isActive ? searchResult : restaurantListFromFirebase
        
        //Create and prepare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoLIstItemCell", for: indexPath) as! RestoListItemCell
        
        
        cell.restoNameLbl.text = restaurantListFromFirebase[indexPath.row].name
        cell.restoLocationLbl.text = restaurantListFromFirebase[indexPath.row].location
        cell.restoTypeLbl.text = restaurantListFromFirebase[indexPath.row].type
        
        let restaurantName = restaurantListFromFirebase[indexPath.row].name
        
        let storageRef = Storage.storage().reference()
        let referance = storageRef.child("\(restaurantName)image.png")
        print("referance is : \(referance)")
        
        let placeholderImage = UIImage(named: "photoalbum")
        
        
        cell.restoPhotoImage.image = nil
        cell.restoPhotoImage.sd_setImage(with: referance, placeholderImage: placeholderImage) // = UIImage(named: "photoalbum") //UIImage(data: (restaurants[indexPath.row].image as Data?)!)
        
        return cell
    }
}

extension RestoListViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}
