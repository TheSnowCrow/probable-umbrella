//
//  EncountersView.swift
//  ClinicVisitTracker
//
//  Main timer and manual entry view
//

import SwiftUI

struct EncountersView: View {
    @StateObject private var timerVM = TimerViewModel()
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selectedVerse = BibleVerses.shared.randomVerse()
    @State private var showingVisitForm = false
    @State private var showingManualEntry = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Bible Verse Banner
                    VStack(spacing: 8) {
                        Text(selectedVerse.text)
                            .font(.body)
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.9))

                        Text("- \(selectedVerse.reference)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.04, green: 0.52, blue: 1.0).opacity(0.2))
                    )
                    .padding(.horizontal)

                    // Timer Section
                    VStack(spacing: 20) {
                        Text("Encounter #\(timerVM.encounterCount + 1)")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))

                        Text(timerVM.formattedTime)
                            .font(.system(size: 72, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)

                        // Timer Controls
                        HStack(spacing: 16) {
                            if timerVM.state == .ready {
                                Button(action: {
                                    timerVM.startTimer()
                                }) {
                                    Label("Start", systemImage: "play.fill")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            } else if timerVM.state == .running {
                                Button(action: {
                                    timerVM.pauseTimer()
                                }) {
                                    Label("Pause", systemImage: "pause.fill")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }

                                Button(action: {
                                    timerVM.endTimer()
                                    showingVisitForm = true
                                }) {
                                    Label("End", systemImage: "stop.fill")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            } else if timerVM.state == .paused {
                                Button(action: {
                                    timerVM.resumeTimer()
                                }) {
                                    Label("Resume", systemImage: "play.fill")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }

                                Button(action: {
                                    timerVM.endTimer()
                                    showingVisitForm = true
                                }) {
                                    Label("End", systemImage: "stop.fill")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(white: 0.15))
                    )
                    .padding(.horizontal)

                    // Manual Entry Button
                    Button(action: {
                        showingManualEntry = true
                    }) {
                        Label("Manual Entry", systemImage: "square.and.pencil")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(white: 0.2))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color(white: 0.12).ignoresSafeArea())
            .navigationTitle("Timer")
            .sheet(isPresented: $showingVisitForm) {
                VisitFormView(duration: timerVM.elapsedTime) { success in
                    if success {
                        timerVM.incrementEncounterCount()
                        timerVM.resetTimer()

                        if settingsManager.autoStartTimer {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                timerVM.startTimer()
                            }
                        }
                    }
                    showingVisitForm = false
                }
            }
            .sheet(isPresented: $showingManualEntry) {
                ManualEntryView()
            }
            .onAppear {
                selectedVerse = BibleVerses.shared.randomVerse()
            }
        }
    }
}

#Preview {
    EncountersView()
        .environmentObject(SettingsManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
