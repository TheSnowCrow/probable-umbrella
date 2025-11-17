//
//  QIProject+CoreDataProperties.swift
//  ClinicVisitTracker
//
//  Core Data properties for QIProject
//

import Foundation
import CoreData

extension QIProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QIProject> {
        return NSFetchRequest<QIProject>(entityName: "QIProject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var projectDescription: String?
    @NSManaged public var variables: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension QIProject {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: QIProjectEntry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: QIProjectEntry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension QIProject : Identifiable {

}
