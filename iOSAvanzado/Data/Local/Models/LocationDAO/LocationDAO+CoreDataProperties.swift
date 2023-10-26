//
//  LocationDAO+CoreDataProperties.swift
//  iOSAvanzado
//
//  Created by Dana Gonzalo on 26/10/23.
//
//

import Foundation
import CoreData


extension LocationDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDAO> {
        return NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var hero: HeroDAO?

}

extension LocationDAO : Identifiable {

}
