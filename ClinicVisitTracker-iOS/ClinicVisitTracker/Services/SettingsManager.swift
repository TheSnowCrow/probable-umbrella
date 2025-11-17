//
//  SettingsManager.swift
//  ClinicVisitTracker
//
//  App settings and user preferences
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    @Published var wrvuConversionRate: Double {
        didSet {
            UserDefaults.standard.set(wrvuConversionRate, forKey: "wrvuConversionRate")
        }
    }

    @Published var autoStartTimer: Bool {
        didSet {
            UserDefaults.standard.set(autoStartTimer, forKey: "autoStartTimer")
        }
    }

    @Published var showMoneyValues: Bool {
        didSet {
            UserDefaults.standard.set(showMoneyValues, forKey: "showMoneyValues")
        }
    }

    init() {
        self.wrvuConversionRate = UserDefaults.standard.double(forKey: "wrvuConversionRate")
        if self.wrvuConversionRate == 0.0 {
            self.wrvuConversionRate = 36.0 // Default $36 per wRVU
        }

        self.autoStartTimer = UserDefaults.standard.bool(forKey: "autoStartTimer")
        self.showMoneyValues = UserDefaults.standard.bool(forKey: "showMoneyValues")
    }

    func calculateMoneyValue(wrvu: Double) -> Double {
        return wrvu * wrvuConversionRate
    }

    func formatMoney(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
