//
//  TimerViewModel.swift
//  ClinicVisitTracker
//
//  Manages timer state and visit tracking
//

import Foundation
import Combine
import SwiftUI

class TimerViewModel: ObservableObject {
    enum TimerState {
        case ready
        case running
        case paused
        case complete
    }

    @Published var state: TimerState = .ready
    @Published var elapsedTime: Int = 0 // Active seconds only
    @Published var encounterCount: Int = 0

    private var timer: Timer?
    private var startTime: Date?
    private var pauseStartTime: Date?
    private var totalPausedTime: TimeInterval = 0

    var formattedTime: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        state = .running
        startTime = Date()
        totalPausedTime = 0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    func pauseTimer() {
        state = .paused
        pauseStartTime = Date()
        timer?.invalidate()
        timer = nil
    }

    func resumeTimer() {
        if let pauseStart = pauseStartTime {
            totalPausedTime += Date().timeIntervalSince(pauseStart)
        }
        pauseStartTime = nil
        state = .running

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }

    func endTimer() {
        state = .complete
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        state = .ready
        elapsedTime = 0
        startTime = nil
        pauseStartTime = nil
        totalPausedTime = 0
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsedTime() {
        guard let start = startTime else { return }
        let totalElapsed = Date().timeIntervalSince(start)
        elapsedTime = Int(totalElapsed - totalPausedTime)
    }

    func incrementEncounterCount() {
        encounterCount += 1
    }
}
