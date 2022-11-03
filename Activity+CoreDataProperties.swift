//
//  Activity+CoreDataProperties.swift
//  CityWeatherApp
//
//  Created by Wajeeha on 2022-10-16.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var activityName: String?
    @NSManaged public var city: City?

}

extension Activity : Identifiable {

}
