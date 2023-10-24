//
//  LocationDAO.swift
//  DragonBall
//
//  Created by David Jardon on 16/10/23.
//

import Foundation
import CoreData

@objc(LocationDAO)
class LocationDAO: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var date: String?
    @NSManaged var hero: HeroDAO?
}
