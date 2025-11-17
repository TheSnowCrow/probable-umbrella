//
//  DashboardView.swift
//  ClinicVisitTracker
//
//  Dashboard with charts and analytics
//

import SwiftUI
import Charts
import CoreData

enum TimePeriod: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case last30 = "Last 30 Days"
    case allTime = "All Time"
    case custom = "Custom"
}

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var selectedPeriod: TimePeriod = .today
    @State private var visits: [Visit] = []
    @State private var showingCustomDatePicker = false
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()

    var totalVisits: Int { visits.count }
    var totalDuration: Int { visits.reduce(0) { $0 + Int($1.activeDuration) } }
    var averageDuration: Int { totalVisits > 0 ? totalDuration / totalVisits : 0 }
    var totalWRVU: Double { visits.reduce(0) { $0 + $1.wrvu } }
    var averageWRVU: Double { totalVisits > 0 ? totalWRVU / Double(totalVisits) : 0 }
    var totalValue: Double { settingsManager.calculateMoneyValue(wrvu: totalWRVU) }

    var visitTypeData: [(String, Int)] {
        var counts: [String: Int] = [:]
        for visit in visits {
            counts[visit.visitType ?? "Unknown", default: 0] += 1
        }
        return counts.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }

    var codeDistribution: [(String, Int)] {
        var counts: [String: Int] = [:]
        for visit in visits {
            let codes = decodeBillingCodes(visit.billingCodes)
            for code in codes {
                counts[code, default: 0] += 1
            }
        }
        return counts.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }.prefix(10).map { $0 }
    }

    var dailyVisitData: [(Date, Int)] {
        var counts: [Date: Int] = [:]
        let calendar = Calendar.current

        for visit in visits {
            if let date = visit.date {
                let day = calendar.startOfDay(for: date)
                counts[day, default: 0] += 1
            }
        }

        return counts.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Period Selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: selectedPeriod) { _ in
                        if selectedPeriod == .custom {
                            showingCustomDatePicker = true
                        } else {
                            loadVisits()
                        }
                    }

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

                    // Visit Type Chart
                    if !visitTypeData.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Visit Type Distribution")
                                .font(.headline)
                                .padding(.horizontal)

                            Chart(visitTypeData, id: \.0) { item in
                                SectorMark(
                                    angle: .value("Count", item.1),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 2
                                )
                                .foregroundStyle(by: .value("Type", item.0))
                                .annotation(position: .overlay) {
                                    Text("\(item.1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color(white: 0.15))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    // Billing Code Distribution
                    if !codeDistribution.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Billing Codes")
                                .font(.headline)
                                .padding(.horizontal)

                            Chart(codeDistribution, id: \.0) { item in
                                BarMark(
                                    x: .value("Count", item.1),
                                    y: .value("Code", item.0)
                                )
                                .foregroundStyle(Color(red: 0.04, green: 0.52, blue: 1.0))
                                .annotation(position: .trailing) {
                                    Text("\(item.1)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(height: max(200, CGFloat(codeDistribution.count * 30)))
                            .padding()
                            .background(Color(white: 0.15))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    // Visits Over Time
                    if dailyVisitData.count > 1 {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Visits Over Time")
                                .font(.headline)
                                .padding(.horizontal)

                            Chart(dailyVisitData, id: \.0) { item in
                                LineMark(
                                    x: .value("Date", item.0),
                                    y: .value("Visits", item.1)
                                )
                                .foregroundStyle(Color(red: 0.04, green: 0.52, blue: 1.0))
                                .symbol(Circle())

                                AreaMark(
                                    x: .value("Date", item.0),
                                    y: .value("Visits", item.1)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.04, green: 0.52, blue: 1.0).opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color(white: 0.15))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Color(white: 0.12).ignoresSafeArea())
            .navigationTitle("Dashboard")
            .onAppear {
                loadVisits()
            }
            .sheet(isPresented: $showingCustomDatePicker) {
                NavigationView {
                    Form {
                        DatePicker("Start Date", selection: $customStartDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $customEndDate, displayedComponents: .date)
                    }
                    .navigationTitle("Custom Date Range")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                selectedPeriod = .today
                                showingCustomDatePicker = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Apply") {
                                showingCustomDatePicker = false
                                loadVisits()
                            }
                        }
                    }
                }
            }
        }
    }

    private func loadVisits() {
        let calendar = Calendar.current
        var startDate: Date
        var endDate = Date()

        switch selectedPeriod {
        case .today:
            startDate = calendar.startOfDay(for: Date())
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        case .last30:
            startDate = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        case .allTime:
            startDate = Date.distantPast
        case .custom:
            startDate = calendar.startOfDay(for: customStartDate)
            endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: customEndDate)) ?? customEndDate
        }

        let fetchRequest: NSFetchRequest<Visit> = Visit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Visit.date, ascending: true)]

        do {
            visits = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching visits: \(error)")
            visits = []
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

    private func decodeBillingCodes(_ codesString: String?) -> [String] {
        guard let codesString = codesString else { return [] }
        if let data = codesString.data(using: .utf8),
           let codes = try? JSONDecoder().decode([String].self, from: data) {
            return codes
        }
        return [codesString]
    }
}

#Preview {
    DashboardView()
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
