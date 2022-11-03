//
//  EditCityViewController.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-14.
//

import UIKit
import CoreData


class EditCityViewController: UIViewController, UISearchControllerDelegate, UITableViewDataSource, didFinishSearchDelegate {
    
    var cityList = CityListViewModel()
    var selectedCityName : String? = nil
    lazy var resultsTableViewController = self.storyboard?.instantiateViewController(withIdentifier:"searchTableViewController") as? SearchCityTableViewController
    lazy var searchController = UISearchController(searchResultsController : resultsTableViewController)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editStackView: UIStackView!
    
    @IBOutlet weak var activityText: UITextField!
    
    lazy var newItems = [NSManagedObject?]()
    lazy var xactivityList : [Activity]? = [Activity]()  {
        didSet {// there is a better
            tableView.reloadData()
        }
    }
    var thisCity : City? = nil {
        didSet{
            
          
        }
    }
    
    //NSManagedObject represents a single object stored in Core Data use it to create, edit, save and delete from your Core Data persistent store
    
    init?(coder: NSCoder, city : City) {
        super.init(coder: coder)
        thisCity = city
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thisCity = thisCity{
            editStackView.isHidden = false
            xactivityList = thisCity.activities?.allObjects as? [Activity]
            self.navigationItem.title = thisCity.cityName
 
        }else{
            editStackView.isHidden = true
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
            resultsTableViewController?.delegate = self
        }
    }
        
    @IBAction func addActivity() {
        let activity = Activity(context: DataManager.shared.persistentContainer.viewContext)
        if !(activityText.text!.isEmpty)
        {
        activity.activityName = activityText.text
        
        thisCity?.addToActivities(activity)
        
            xactivityList?.append(activity)
            
        }
        self.activityText.text = ""
        //save
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cancel"{
         
                for item in newItems {
                    DataManager.shared.persistentContainer.viewContext.delete(item!)
                }
        }
    }


 
    
    func didFinishSearchWith(cityName: String?) {
        selectedCityName = cityName
        self.navigationItem.title = selectedCityName
        searchController.isActive = false
        if thisCity == nil{
        thisCity = City(context: DataManager.shared.persistentContainer.viewContext)
        }
        newItems.append(thisCity)
        thisCity!.cityName = cityName
        editStackView.isHidden = false
        //DataManager.shared.save()
    }
 

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xactivityList?.count ?? 0
    }
    //don't need to set up the table view’s delegate since tapping on the cells won’t trigger any action
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let activity = activityList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = xactivityList?[indexPath.row].activityName
        //cell.textLabel?.text = activity.value(forKeyPath: "name") as? String
        return cell
    }
    
}

extension EditCityViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        if( text.count > 2){
            Task {
                do {
                    await cityList.search(name: text)
                    resultsTableViewController?.cityList = cityList.cities
                }
            }
        }
    }
}
