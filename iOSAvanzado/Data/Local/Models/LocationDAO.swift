//
//  LocationDAO+CoreDataProperties.swift
//  iOSAvanzado
//
//  Created by Dana Gonzalo on 26/10/23.
//
//

import Foundation
import CoreData


@objc(LocationDAO)
public class LocationDAO: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDAO> {
        return NSFetchRequest<LocationDAO>(entityName: "HeroDAO")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var hero: HeroDAO?
}

extension LocationDAO : Identifiable { }

extension LocationDAO: ModelConvertible {
    static var entityName = "LocationDAO"
    
    func toModel() -> HeroLocation? {
        return HeroLocation(
            id: id,
            latitude: latitude,
            longitude: longitude,
            date: date,
            hero: hero?.toModel()
        )
    }
}
