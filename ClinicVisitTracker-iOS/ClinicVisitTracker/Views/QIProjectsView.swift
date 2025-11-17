//
//  QIProjectsView.swift
//  ClinicVisitTracker
//
//  Quality Improvement project tracker
//

import SwiftUI
import CoreData

struct QIProjectsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: QIProject.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \QIProject.createdAt, ascending: false)]
    ) var projects: FetchedResults<QIProject>

    @State private var showingCreateProject = false
    @State private var selectedProject: QIProject?

    var body: some View {
        NavigationView {
            List {
                if projects.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        Text("No QI Projects")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Text("Create a project to start tracking quality improvement initiatives")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            showingCreateProject = true
                        }) {
                            Label("Create Project", systemImage: "plus.circle.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(projects) { project in
                        Button(action: {
                            selectedProject = project
                        }) {
                            QIProjectRow(project: project)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteProjects)
                }
            }
            .listStyle(.insetGrouped)
            .background(Color(white: 0.12).ignoresSafeArea())
            .navigationTitle("QI Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateProject = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateProject) {
                CreateQIProjectView()
            }
            .sheet(item: $selectedProject) { project in
                QIProjectDetailView(project: project)
            }
        }
    }

    private func deleteProjects(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(projects[index])
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting projects: \(error)")
        }
    }
}

struct QIProjectRow: View {
    @ObservedObject var project: QIProject

    var entryCount: Int {
        (project.entries as? Set<QIProjectEntry>)?.count ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(project.name ?? "Untitled Project")
                .font(.headline)

            if let description = project.projectDescription, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Label("\(entryCount) entries", systemImage: "chart.bar.doc.horizontal")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if let date = project.createdAt {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct CreateQIProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var projectName = ""
    @State private var projectDescription = ""
    @State private var variables: [QIVariable] = []
    @State private var showingAddVariable = false

    var body: some View {
        NavigationView {
            Form {
                Section("Project Information") {
                    TextField("Project Name", text: $projectName)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextEditor(text: $projectDescription)
                            .frame(height: 100)
                    }
                }

                Section {
                    ForEach(variables) { variable in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(variable.name)
                                .font(.headline)
                            Text(variable.type.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if variable.type == "dropdown", let options = variable.options {
                                Text(options.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indices in
                        variables.remove(atOffsets: indices)
                    }

                    Button(action: {
                        showingAddVariable = true
                    }) {
                        Label("Add Variable", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Data Variables")
                } footer: {
                    Text("Define the data points you want to track for this project")
                }
            }
            .navigationTitle("New QI Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        saveProject()
                    }
                    .disabled(projectName.isEmpty || variables.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddVariable) {
                AddQIVariableView { variable in
                    variables.append(variable)
                    showingAddVariable = false
                }
            }
        }
    }

    private func saveProject() {
        let project = QIProject(context: viewContext)
        project.id = UUID()
        project.name = projectName
        project.projectDescription = projectDescription.isEmpty ? nil : projectDescription
        project.createdAt = Date()

        if let data = try? JSONEncoder().encode(variables),
           let json = String(data: data, encoding: .utf8) {
            project.variables = json
        }

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving project: \(error)")
        }
    }
}

struct QIVariable: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String // "text", "number", "dropdown", "date"
    var options: [String]? // For dropdown type
}

struct AddQIVariableView: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (QIVariable) -> Void

    @State private var variableName = ""
    @State private var variableType = "text"
    @State private var optionsText = ""

    private let variableTypes = ["text", "number", "dropdown", "date"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Variable Name", text: $variableName)

                Picker("Type", selection: $variableType) {
                    ForEach(variableTypes, id: \.self) { type in
                        Text(type.capitalized).tag(type)
                    }
                }

                if variableType == "dropdown" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Options (one per line)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        TextEditor(text: $optionsText)
                            .frame(height: 120)
                            .border(Color.gray.opacity(0.3))
                    }
                }
            }
            .navigationTitle("Add Variable")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let options: [String]? = variableType == "dropdown" ?
                            optionsText.components(separatedBy: "\n")
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .filter { !$0.isEmpty } : nil

                        let variable = QIVariable(name: variableName, type: variableType, options: options)
                        onSave(variable)
                    }
                    .disabled(variableName.isEmpty)
                }
            }
        }
    }
}

struct QIProjectDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var project: QIProject

    @State private var showingAddEntry = false
    @State private var entries: [QIProjectEntry] = []

    var variables: [QIVariable] {
        guard let variablesString = project.variables,
              let data = variablesString.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([QIVariable].self, from: data) else {
            return []
        }
        return decoded
    }

    var body: some View {
        NavigationView {
            List {
                Section("Project Info") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(project.name ?? "Untitled")
                            .font(.title2)
                            .fontWeight(.bold)

                        if let description = project.projectDescription {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Variables") {
                    ForEach(variables) { variable in
                        HStack {
                            Text(variable.name)
                            Spacer()
                            Text(variable.type.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section {
                    ForEach(entries) { entry in
                        QIEntryRow(entry: entry, variables: variables)
                    }
                    .onDelete(perform: deleteEntries)
                } header: {
                    HStack {
                        Text("Data Entries (\(entries.count))")
                        Spacer()
                        Button(action: {
                            showingAddEntry = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(Color(white: 0.12).ignoresSafeArea())
            .navigationTitle("Project Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddQIEntryView(project: project, variables: variables) {
                    loadEntries()
                    showingAddEntry = false
                }
            }
            .onAppear {
                loadEntries()
            }
        }
    }

    private func loadEntries() {
        entries = (project.entries as? Set<QIProjectEntry>)?.sorted {
            ($0.createdAt ?? Date()) > ($1.createdAt ?? Date())
        } ?? []
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(entries[index])
        }

        do {
            try viewContext.save()
            loadEntries()
        } catch {
            print("Error deleting entries: \(error)")
        }
    }
}

struct QIEntryRow: View {
    let entry: QIProjectEntry
    let variables: [QIVariable]

    var entryData: [String: String] {
        guard let dataString = entry.entryData,
              let data = dataString.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
            return [:]
        }
        return decoded
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let date = entry.createdAt {
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ForEach(variables) { variable in
                if let value = entryData[variable.name], !value.isEmpty {
                    HStack {
                        Text(variable.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(value)
                            .font(.body)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddQIEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let project: QIProject
    let variables: [QIVariable]
    let onSave: () -> Void

    @State private var entryData: [String: String] = [:]

    var body: some View {
        NavigationView {
            Form {
                ForEach(variables) { variable in
                    QIVariableInput(variable: variable, value: Binding(
                        get: { entryData[variable.name] ?? "" },
                        set: { entryData[variable.name] = $0 }
                    ))
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                }
            }
        }
    }

    private func saveEntry() {
        let entry = QIProjectEntry(context: viewContext)
        entry.id = UUID()
        entry.createdAt = Date()
        entry.project = project

        if let data = try? JSONEncoder().encode(entryData),
           let json = String(data: data, encoding: .utf8) {
            entry.entryData = json
        }

        do {
            try viewContext.save()
            onSave()
        } catch {
            print("Error saving entry: \(error)")
        }
    }
}

struct QIVariableInput: View {
    let variable: QIVariable
    @Binding var value: String

    @State private var selectedDate = Date()

    var body: some View {
        switch variable.type {
        case "text":
            TextField(variable.name, text: $value)

        case "number":
            HStack {
                Text(variable.name)
                TextField("Value", text: $value)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }

        case "dropdown":
            Picker(variable.name, selection: $value) {
                Text("").tag("")
                if let options = variable.options {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }

        case "date":
            DatePicker(variable.name, selection: $selectedDate, displayedComponents: .date)
                .onChange(of: selectedDate) { newDate in
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    value = formatter.string(from: newDate)
                }

        default:
            TextField(variable.name, text: $value)
        }
    }
}

#Preview {
    QIProjectsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
