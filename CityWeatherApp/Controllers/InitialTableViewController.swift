//
//  InitialTableViewController.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-14.
//

import UIKit
import CoreData

class InitialTableViewController: UITableViewController {

    
    lazy var myFetchResultController : NSFetchedResultsController<City> = {
        
        let fetch : NSFetchRequest<City> = City.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: true)]
        
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: DataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
         ftc.delegate = self
         
        return ftc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? myFetchResultController.performFetch()
         
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myFetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! InitialTableViewCell
        let item = myFetchResultController.object(at: indexPath)
      
        cell.configureCell(item: item)
        
        
        // Configure the cell...

        return cell
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = myFetchResultController.object(at: indexPath)
            DataManager.shared.persistentContainer.viewContext.delete(obj)
            DataManager.shared.save()
        }
    }

     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let selected = tableView.indexPathForSelectedRow{
                let city = myFetchResultController.object(at: selected)
                (segue.destination as! EditCityViewController).thisCity = city
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    @IBAction func unwindSave(segue: UIStoryboardSegue) {
        guard segue.identifier == "save" else {return }
        let sourceViewController = segue.source as! EditCityViewController
        if let _ = sourceViewController.thisCity {
            DataManager.shared.save()
        }
    }
     
    
}
extension InitialTableViewController : NSFetchedResultsControllerDelegate {
    // These methods are called by the iOS runtime, in response to user interaction and/or changes in the data source
    
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update(s)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    }
}
extension InitialTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate? = nil
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "cityName CONTAINS[c] %@ ", searchText)
        }
        myFetchResultController.fetchRequest.predicate = predicate
        try? myFetchResultController.performFetch()
        tableView.reloadData()
        
    }
}
