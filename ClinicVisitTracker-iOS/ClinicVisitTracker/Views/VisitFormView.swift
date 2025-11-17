//
//  VisitFormView.swift
//  ClinicVisitTracker
//
//  Form for completing a visit after timer ends
//

import SwiftUI

struct VisitFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss

    let duration: Int
    let onSave: (Bool) -> Void

    @State private var visitType = "Sick"
    @State private var selectedCodes: Set<String> = []
    @State private var comments = ""
    @State private var customFieldValues: [String: String] = [:]

    @FetchRequest(
        entity: CustomField.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CustomField.sortOrder, ascending: true)]
    ) var customFields: FetchedResults<CustomField>

    private let visitTypes = ["Sick", "Well", "Both"]
    private let wrvuLookup = WRVULookup.shared

    var totalWRVU: Double {
        wrvuLookup.calculateTotalWRVU(for: Array(selectedCodes))
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Visit Type") {
                    Picker("Type", selection: $visitType) {
                        ForEach(visitTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Duration") {
                    HStack {
                        Text("Active Time")
                        Spacer()
                        Text(formatDuration(duration))
                            .foregroundColor(.secondary)
                    }

                    if !suggestedCodes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Suggested for \(duration/60) minutes:")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button(action: {
                                selectedCodes = Set(suggestedCodes)
                                if visitType == "Both" {
                                    selectedCodes.insert("25")
                                }
                            }) {
                                Text("Use Suggested Codes")
                                    .font(.subheadline)
                            }
                        }
                    }
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

                    if settingsManager.showMoneyValues {
                        HStack {
                            Text("Value")
                                .font(.headline)
                            Spacer()
                            Text(settingsManager.formatMoney(settingsManager.calculateMoneyValue(wrvu: totalWRVU)))
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                }

                if !customFields.isEmpty {
                    Section("Custom Fields") {
                        ForEach(customFields) { field in
                            CustomFieldInput(
                                field: field,
                                value: Binding(
                                    get: { customFieldValues[field.name ?? ""] ?? "" },
                                    set: { customFieldValues[field.name ?? ""] = $0 }
                                )
                            )
                        }
                    }
                }

                Section("Comments") {
                    TextEditor(text: $comments)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Complete Visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onSave(false)
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

    private var suggestedCodes: [String] {
        wrvuLookup.suggestedCodesForDuration(duration, visitType: visitType)
    }

    private func toggleCode(_ code: String) {
        if selectedCodes.contains(code) {
            selectedCodes.remove(code)
        } else {
            selectedCodes.insert(code)
        }

        // Auto-add modifier 25 if both well and sick codes are selected
        if visitType == "Both" && !selectedCodes.contains("25") {
            selectedCodes.insert("25")
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }

    private func saveVisit() {
        let visit = Visit(context: viewContext)
        visit.id = UUID()
        visit.date = Date()
        visit.startTime = Date().addingTimeInterval(-Double(duration))
        visit.endTime = Date()
        visit.activeDuration = Int32(duration)
        visit.visitType = visitType
        visit.billingCodes = encodeCodesAsJSON(Array(selectedCodes))
        visit.comments = comments.isEmpty ? nil : comments
        visit.wrvu = totalWRVU

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: visit.date!)
        let formatter = DateFormatter()
        visit.dayOfWeek = formatter.weekdaySymbols[weekday - 1]

        if !customFieldValues.isEmpty {
            visit.customFieldsData = encodeCustomFieldsAsJSON(customFieldValues)
        }

        do {
            try viewContext.save()
            onSave(true)
        } catch {
            print("Error saving visit: \(error)")
            onSave(false)
        }
    }

    private func encodeCodesAsJSON(_ codes: [String]) -> String {
        if let data = try? JSONEncoder().encode(codes),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "[]"
    }

    private func encodeCustomFieldsAsJSON(_ fields: [String: String]) -> String {
        if let data = try? JSONEncoder().encode(fields),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }
}

struct BillingCodeButton: View {
    let code: BillingCode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(code.code)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.bold)
                Text(String(format: "%.2f", code.wrvu))
                    .font(.caption2)
                    .opacity(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color(red: 0.04, green: 0.52, blue: 1.0) : Color(white: 0.2))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

struct CustomFieldInput: View {
    let field: CustomField
    @Binding var value: String

    var body: some View {
        if field.fieldType == "dropdown" {
            Picker(field.name ?? "", selection: $value) {
                Text("").tag("")
                if let optionsString = field.options,
                   let data = optionsString.data(using: .utf8),
                   let options = try? JSONDecoder().decode([String].self, from: data) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }
        } else if field.fieldType == "number" {
            HStack {
                Text(field.name ?? "")
                TextField("Value", text: $value)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    VisitFormView(duration: 600) { _ in }
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
