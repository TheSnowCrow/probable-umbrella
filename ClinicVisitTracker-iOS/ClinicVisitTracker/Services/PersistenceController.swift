//
//  PersistenceController.swift
//  ClinicVisitTracker
//
//  Core Data stack manager
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ClinicVisitTracker")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        // Create sample data for previews
        let visit = Visit(context: context)
        visit.id = UUID()
        visit.date = Date()
        visit.visitType = "Sick"
        visit.activeDuration = 600 // 10 minutes
        visit.billingCodes = "[\"99213\"]"
        visit.wrvu = 1.30
        visit.dayOfWeek = "Monday"

        do {
            try context.save()
        } catch {
            fatalError("Failed to create preview data: \(error)")
        }

        return controller
    }()

    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
