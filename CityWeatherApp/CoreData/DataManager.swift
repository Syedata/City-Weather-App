//
//  DataManager.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-16.
//

import Foundation
import CoreData
class DataManager {
    static var shared = DataManager()
    private init() {}
    //To manage data creation, fetching and deletion we are going to create a class called DataManager by firstly creating the NSPersistentContainer and saving the context.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CityWeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Core Data Saving support
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Methods responsible for city object and activity object creation implemented below. addToActivities(_value: Activity) method relates the activity to its city object as a parameter of the activity method.
//    func city(cityName: String) -> City {
//        let city = City(context: persistentContainer.viewContext)
//        city.cityName = cityName
//        return city
//    }
//
//    func activity(name: String, city: City) -> Activity {
//        let activity = Activity(context: persistentContainer.viewContext)
//        activity.activityName = name
//        city.addToActivities(activity)
//        return activity
//    }
//
//    //implement methods responsible for fetching data of each type. To fetch the activities we must add a predicate to the NSFetchRequest so Core Data will ensure that only the matching objects, activities that belong to the City object, will get returned.
//    func cities() -> [City] {
//        let request: NSFetchRequest<City> = City.fetchRequest()
//        var fetchedCities: [City] = []
//        do {
//            fetchedCities = try persistentContainer.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching cities \(error)")
//        }
//
//        return fetchedCities.sorted { a, b in
//            a.cityName! < b.cityName!
//        }
//    }
//
//    func activities(city: City) -> [Activity] {
//        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
//        request.predicate = NSPredicate(format: "city = %@", city)
//        request.sortDescriptors = [NSSortDescriptor(key: "activityName", ascending: false)]
//        var fetchedActivities: [Activity] = []
//        do {
//            fetchedActivities = try persistentContainer.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching songs \(error)")
//        }
//
//        return fetchedActivities
//    }
//
//    //Methods responsible for deletion of each data type
//    func deleteActivity(activity: Activity) {
//        let context = persistentContainer.viewContext
//        context.delete(activity)
//        save()
//    }
//
//    func deleteCity(city: City) {
//        let context = persistentContainer.viewContext
//        context.delete(city)
//        save()
//    }
}
