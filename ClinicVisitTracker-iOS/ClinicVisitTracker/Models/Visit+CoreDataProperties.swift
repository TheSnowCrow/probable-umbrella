//
//  Visit+CoreDataProperties.swift
//  ClinicVisitTracker
//
//  Core Data properties for Visit
//

import Foundation
import CoreData

extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var activeDuration: Int32
    @NSManaged public var visitType: String?
    @NSManaged public var billingCodes: String?
    @NSManaged public var comments: String?
    @NSManaged public var customFieldsData: String?
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var wrvu: Double

}

extension Visit : Identifiable {

}
