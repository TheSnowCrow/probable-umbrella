//
//  ClinicVisitTrackerApp.swift
//  ClinicVisitTracker
//
//  Main app entry point for Clinic Visit Tracker iOS
//

import SwiftUI

@main
struct ClinicVisitTrackerApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsManager)
                .preferredColorScheme(.dark)
        }
    }
}
