//
//  SettingsView.swift
//  ClinicVisitTracker
//
//  App settings and configuration
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settingsManager: SettingsManager

    @FetchRequest(
        entity: CustomField.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CustomField.sortOrder, ascending: true)]
    ) var customFields: FetchedResults<CustomField>

    @State private var showingAddField = false
    @State private var newFieldName = ""
    @State private var newFieldType = "dropdown"
    @State private var newFieldOptions = ""

    var body: some View {
        NavigationView {
            Form {
                Section("General Settings") {
                    HStack {
                        Text("wRVU Conversion Rate")
                        Spacer()
                        Text("$")
                        TextField("Rate", value: $settingsManager.wrvuConversionRate, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    Toggle("Auto-start Timer", isOn: $settingsManager.autoStartTimer)

                    Toggle("Show Money Values", isOn: $settingsManager.showMoneyValues)
                }

                Section {
                    ForEach(customFields) { field in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(field.name ?? "Unknown")
                                    .font(.headline)
                                Text(field.fieldType?.capitalized ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                if field.fieldType == "dropdown", let options = field.options {
                                    if let data = options.data(using: .utf8),
                                       let optionArray = try? JSONDecoder().decode([String].self, from: data) {
                                        Text(optionArray.joined(separator: ", "))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            Spacer()

                            Button(role: .destructive) {
                                deleteField(field)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    Button(action: {
                        showingAddField = true
                    }) {
                        Label("Add Custom Field", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Custom Fields")
                } footer: {
                    Text("Create custom fields to track additional data during visits")
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Billing Codes")
                        Spacer()
                        Text("\(WRVULookup.shared.allCodes.count) codes")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAddField) {
                NavigationView {
                    Form {
                        TextField("Field Name", text: $newFieldName)

                        Picker("Field Type", selection: $newFieldType) {
                            Text("Dropdown").tag("dropdown")
                            Text("Number").tag("number")
                        }
                        .pickerStyle(.segmented)

                        if newFieldType == "dropdown" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Options (one per line)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                TextEditor(text: $newFieldOptions)
                                    .frame(height: 120)
                                    .border(Color.gray.opacity(0.3))
                            }
                        }
                    }
                    .navigationTitle("Add Custom Field")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                resetForm()
                                showingAddField = false
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                saveCustomField()
                            }
                            .disabled(newFieldName.isEmpty)
                        }
                    }
                }
            }
        }
    }

    private func saveCustomField() {
        let field = CustomField(context: viewContext)
        field.id = UUID()
        field.name = newFieldName
        field.fieldType = newFieldType
        field.sortOrder = Int16(customFields.count)

        if newFieldType == "dropdown" {
            let options = newFieldOptions.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            if let data = try? JSONEncoder().encode(options),
               let json = String(data: data, encoding: .utf8) {
                field.options = json
            }
        }

        do {
            try viewContext.save()
            resetForm()
            showingAddField = false
        } catch {
            print("Error saving custom field: \(error)")
        }
    }

    private func deleteField(_ field: CustomField) {
        viewContext.delete(field)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting field: \(error)")
        }
    }

    private func resetForm() {
        newFieldName = ""
        newFieldType = "dropdown"
        newFieldOptions = ""
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
