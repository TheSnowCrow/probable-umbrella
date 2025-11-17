//
//  QIProjectEntry+CoreDataProperties.swift
//  ClinicVisitTracker
//
//  Core Data properties for QIProjectEntry
//

import Foundation
import CoreData

extension QIProjectEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QIProjectEntry> {
        return NSFetchRequest<QIProjectEntry>(entityName: "QIProjectEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var entryData: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var project: QIProject?

}

extension QIProjectEntry : Identifiable {

}
