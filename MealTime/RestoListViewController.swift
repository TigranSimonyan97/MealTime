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
import AlamofireImage

class RestoListViewController: UITableViewController
{
    
    var refreshController: UIRefreshControl!
    var searchController: UISearchController!
    
    
    //Properties
    var restaurantList: [Restaurant] = []
    var restaurant: Restaurant!
    
    
    //Using Firebas
    var restaurantListFromFirebase: [RestaurantModel] = []
    var restaurantFIR: RestaurantModel?
    
    
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
        
        
        //refresh table view
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshTableView), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
        
        getRestaurants()
        
    }
    
    
    func refreshTableView()
    {
        tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRestaurantsFromFIRDB()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestoDetail"{
            let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurantFIR = self.restaurantFIR
//                destinationController.restaurant = self.restaurant
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
                        if (!self.isRestaurantAlreadyExist(restaurant: restaurant)){
                            self.restaurantListFromFirebase.append(restaurant)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func isRestaurantAlreadyExist(restaurant:RestaurantModel) -> Bool
    {
        var restaurantsName:[String] = []
        for restaurant in self.restaurantListFromFirebase {
            restaurantsName.append(restaurant.name)
        }
        
        return restaurantsName.contains(restaurant.name)
    }
    
    func getRestaurantImageFromFIRStorage(indexPathRow: Int) -> URL? {
    
        var imageURL: URL?
        let restaurantName = restaurantListFromFirebase[indexPathRow].name
        
        let storageRef = Storage.storage().reference()
        let referance = storageRef.child("\(restaurantName)image.png")
        
        referance.downloadURL { (url, error) in
            if error != nil{
                print ("error is: \(error.debugDescription)")
            } else {
                imageURL = url
            }
        }
        
        return imageURL
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
        
//        self.restaurant = restaurantList[indexPath.row]
        self.restaurantFIR = restaurantListFromFirebase[indexPath.row]
        self.performSegue(withIdentifier: "showRestoDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let restaurants = searchController.isActive ? searchResult : restaurantListFromFirebase
        
        //Create and prepare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestoLIstItemCell", for: indexPath) as! RestoListItemCell
        
        let restaurant = restaurantListFromFirebase[indexPath.row]
        
        cell.restoNameLbl.text = restaurant.name
        cell.restoLocationLbl.text = restaurant.location
        cell.restoTypeLbl.text = restaurant.type
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(restaurant.name)image.png")
        
        imageRef.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error.debugDescription)
            }else {
                if let imageData = data {
                    cell.restoPhotoImage.image = UIImage(data: imageData)
                }
            }
        }
        
        
        
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
