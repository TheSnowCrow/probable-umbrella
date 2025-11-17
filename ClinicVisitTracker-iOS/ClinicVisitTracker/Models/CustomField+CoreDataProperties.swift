//
//  CustomField+CoreDataProperties.swift
//  ClinicVisitTracker
//
//  Core Data properties for CustomField
//

import Foundation
import CoreData

extension CustomField {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomField> {
        return NSFetchRequest<CustomField>(entityName: "CustomField")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var fieldType: String?
    @NSManaged public var options: String?
    @NSManaged public var sortOrder: Int16

}

extension CustomField : Identifiable {

}
