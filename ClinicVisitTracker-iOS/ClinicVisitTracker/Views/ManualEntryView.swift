//
//  ManualEntryView.swift
//  ClinicVisitTracker
//
//  Manual visit entry view
//

import SwiftUI

struct ManualEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss

    @State private var visitDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var useDuration = false
    @State private var durationMinutes = 15
    @State private var visitType = "Sick"
    @State private var selectedCodes: Set<String> = []
    @State private var comments = ""
    @State private var saveAndStartNext = false

    private let visitTypes = ["Sick", "Well", "Both"]
    private let wrvuLookup = WRVULookup.shared

    var totalWRVU: Double {
        wrvuLookup.calculateTotalWRVU(for: Array(selectedCodes))
    }

    var calculatedDuration: Int {
        if useDuration {
            return durationMinutes * 60
        } else {
            return max(0, Int(endTime.timeIntervalSince(startTime)))
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Date & Time") {
                    DatePicker("Visit Date", selection: $visitDate, displayedComponents: .date)

                    Toggle("Use Duration", isOn: $useDuration)

                    if useDuration {
                        Stepper("Duration: \(durationMinutes) min", value: $durationMinutes, in: 1...120)
                    } else {
                        DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Visit Type") {
                    Picker("Type", selection: $visitType) {
                        ForEach(visitTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Billing Codes") {
                    ForEach(BillingCode.CodeCategory.allCases, id: \.self) { category in
                        if !wrvuLookup.codesByCategory(category).isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(category.displayName)
                                    .font(.headline)
                                    .padding(.top, 8)

                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                                    ForEach(wrvuLookup.codesByCategory(category)) { code in
                                        BillingCodeButton(
                                            code: code,
                                            isSelected: selectedCodes.contains(code.code)
                                        ) {
                                            toggleCode(code.code)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    HStack {
                        Text("Total wRVU")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f", totalWRVU))
                            .font(.headline)
                            .foregroundColor(Color(red: 0.04, green: 0.52, blue: 1.0))
                    }
                }

                Section("Comments") {
                    TextEditor(text: $comments)
                        .frame(minHeight: 80)
                }

                Section {
                    Toggle("Save & Start Next", isOn: $saveAndStartNext)
                }
            }
            .navigationTitle("Manual Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveVisit()
                    }
                    .disabled(selectedCodes.isEmpty)
                }
            }
        }
    }

    private func toggleCode(_ code: String) {
        if selectedCodes.contains(code) {
            selectedCodes.remove(code)
        } else {
            selectedCodes.insert(code)
        }

        if visitType == "Both" && !selectedCodes.contains("25") {
            selectedCodes.insert("25")
        }
    }

    private func saveVisit() {
        let visit = Visit(context: viewContext)
        visit.id = UUID()
        visit.date = visitDate
        visit.activeDuration = Int32(calculatedDuration)
        visit.visitType = visitType
        visit.billingCodes = encodeCodesAsJSON(Array(selectedCodes))
        visit.comments = comments.isEmpty ? nil : comments
        visit.wrvu = totalWRVU

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: visitDate)
        let formatter = DateFormatter()
        visit.dayOfWeek = formatter.weekdaySymbols[weekday - 1]

        if !useDuration {
            visit.startTime = startTime
            visit.endTime = endTime
        }

        do {
            try viewContext.save()

            if saveAndStartNext {
                resetForm()
            } else {
                dismiss()
            }
        } catch {
            print("Error saving visit: \(error)")
        }
    }

    private func resetForm() {
        selectedCodes = []
        comments = ""
        durationMinutes = 15
        startTime = Date()
        endTime = Date()
    }

    private func encodeCodesAsJSON(_ codes: [String]) -> String {
        if let data = try? JSONEncoder().encode(codes),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "[]"
    }
}

#Preview {
    ManualEntryView()
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
