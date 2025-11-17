//
//  DailySummaryView.swift
//  ClinicVisitTracker
//
//  Daily summary with visit list and statistics
//

import SwiftUI
import CoreData

struct DailySummaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var selectedDate = Date()
    @State private var visits: [Visit] = []
    @State private var showDeleteAlert = false
    @State private var visitToDelete: Visit?

    var totalVisits: Int { visits.count }

    var totalDuration: Int {
        visits.reduce(0) { $0 + Int($1.activeDuration) }
    }

    var averageDuration: Int {
        totalVisits > 0 ? totalDuration / totalVisits : 0
    }

    var totalWRVU: Double {
        visits.reduce(0) { $0 + $1.wrvu }
    }

    var averageWRVU: Double {
        totalVisits > 0 ? totalWRVU / Double(totalVisits) : 0
    }

    var totalValue: Double {
        settingsManager.calculateMoneyValue(wrvu: totalWRVU)
    }

    var visitTypeBreakdown: [String: Int] {
        var breakdown: [String: Int] = [:]
        for visit in visits {
            breakdown[visit.visitType ?? "Unknown", default: 0] += 1
        }
        return breakdown
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Selector
                    HStack {
                        Button(action: previousDay) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                        }

                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .onChange(of: selectedDate) { _ in
                                loadVisits()
                            }

                        Button(action: nextDay) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                        }
                    }
                    .padding()

                    // Summary Stats
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            StatCard(title: "Total Visits", value: "\(totalVisits)", icon: "person.3.fill")
                            StatCard(title: "Avg Duration", value: formatDuration(averageDuration), icon: "clock.fill")
                        }

                        HStack(spacing: 12) {
                            StatCard(title: "Total Time", value: formatDuration(totalDuration), icon: "timer")
                            StatCard(title: "Total wRVU", value: String(format: "%.2f", totalWRVU), icon: "chart.bar.fill")
                        }

                        HStack(spacing: 12) {
                            StatCard(title: "Avg wRVU", value: String(format: "%.2f", averageWRVU), icon: "chart.line.uptrend.xyaxis")

                            if settingsManager.showMoneyValues {
                                StatCard(title: "Total Value", value: settingsManager.formatMoney(totalValue), icon: "dollarsign.circle.fill", valueColor: .green)
                            } else {
                                StatCard(title: "Value", value: "Hidden", icon: "eye.slash.fill", valueColor: .secondary)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Visit Type Breakdown
                    if !visitTypeBreakdown.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Visit Types")
                                .font(.headline)
                                .padding(.horizontal)

                            HStack(spacing: 12) {
                                ForEach(Array(visitTypeBreakdown.keys.sorted()), id: \.self) { type in
                                    VStack {
                                        Text("\(visitTypeBreakdown[type] ?? 0)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text(type)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Visit List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Visits")
                            .font(.headline)
                            .padding(.horizontal)

                        if visits.isEmpty {
                            Text("No visits recorded for this date")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(Array(visits.enumerated()), id: \.element.id) { index, visit in
                                VisitRow(visit: visit, encounterNumber: index + 1)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            visitToDelete = visit
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Color(white: 0.12).ignoresSafeArea())
            .navigationTitle("Daily Summary")
            .onAppear {
                loadVisits()
            }
            .alert("Delete Visit", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let visit = visitToDelete {
                        deleteVisit(visit)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this visit?")
            }
        }
    }

    private func previousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }

    private func nextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }

    private func loadVisits() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let fetchRequest: NSFetchRequest<Visit> = Visit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Visit.date, ascending: true)]

        do {
            visits = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching visits: \(error)")
            visits = []
        }
    }

    private func deleteVisit(_ visit: Visit) {
        viewContext.delete(visit)
        do {
            try viewContext.save()
            loadVisits()
        } catch {
            print("Error deleting visit: \(error)")
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return "\(hours)h \(mins)m"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var valueColor: Color = Color(red: 0.04, green: 0.52, blue: 1.0)

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(valueColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(valueColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(12)
    }
}

struct VisitRow: View {
    let visit: Visit
    let encounterNumber: Int

    private var billingCodes: [String] {
        guard let codesString = visit.billingCodes else { return [] }
        if let data = codesString.data(using: .utf8),
           let codes = try? JSONDecoder().decode([String].self, from: data) {
            return codes
        }
        return [codesString]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Encounter #\(encounterNumber)")
                    .font(.headline)

                Spacer()

                Text(String(format: "%.2f wRVU", visit.wrvu))
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.04, green: 0.52, blue: 1.0))
            }

            HStack {
                Label(visit.visitType ?? "Unknown", systemImage: "stethoscope")
                    .font(.subheadline)

                Spacer()

                Text(formatDuration(Int(visit.activeDuration)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !billingCodes.isEmpty {
                Text("Codes: \(billingCodes.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let comments = visit.comments, !comments.isEmpty {
                Text(comments)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(12)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes) min"
    }
}

#Preview {
    DailySummaryView()
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
