//
//  ContentView.swift
//  ClinicVisitTracker
//
//  Main navigation container
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            EncountersView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(0)

            DailySummaryView()
                .tabItem {
                    Label("Daily", systemImage: "calendar")
                }
                .tag(1)

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(2)

            QIProjectsView()
                .tabItem {
                    Label("QI Projects", systemImage: "list.clipboard")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.04, green: 0.52, blue: 1.0)) // #0a84ff
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SettingsManager())
}
