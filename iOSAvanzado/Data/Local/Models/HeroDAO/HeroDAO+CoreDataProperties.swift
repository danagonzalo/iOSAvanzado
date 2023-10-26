//
//  HeroDAO+CoreDataProperties.swift
//  iOSAvanzado
//
//  Created by Dana Gonzalo on 26/10/23.
//
//

import Foundation
import CoreData


extension HeroDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeroDAO> {
        return NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var id: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension HeroDAO {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: LocationDAO)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: LocationDAO)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}

extension HeroDAO : Identifiable {

}
