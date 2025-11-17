//
//  WRVULookup.swift
//  ClinicVisitTracker
//
//  Billing code and wRVU value lookup
//

import Foundation

struct BillingCode: Identifiable, Hashable {
    let id: String
    let code: String
    let wrvu: Double
    let description: String
    let category: CodeCategory

    enum CodeCategory: String, CaseIterable {
        case established = "Established"
        case newPatient = "New Patient"
        case preventiveNew = "Preventive (New)"
        case preventiveEstablished = "Preventive (Est.)"
        case modifier = "Modifier"

        var displayName: String { rawValue }
    }

    init(code: String, wrvu: Double, description: String, category: CodeCategory) {
        self.id = code
        self.code = code
        self.wrvu = wrvu
        self.description = description
        self.category = category
    }
}

class WRVULookup {
    static let shared = WRVULookup()

    let allCodes: [BillingCode] = [
        // Established Patient Visits
        BillingCode(code: "99212", wrvu: 0.70, description: "Est. Patient - Low (10 min)", category: .established),
        BillingCode(code: "99213", wrvu: 1.30, description: "Est. Patient - Moderate (20 min)", category: .established),
        BillingCode(code: "99214", wrvu: 1.92, description: "Est. Patient - High (30 min)", category: .established),
        BillingCode(code: "99215", wrvu: 2.80, description: "Est. Patient - Very High (40 min)", category: .established),

        // New Patient Visits
        BillingCode(code: "99202", wrvu: 0.93, description: "New Patient - Low (15-29 min)", category: .newPatient),
        BillingCode(code: "99203", wrvu: 1.60, description: "New Patient - Moderate (30-44 min)", category: .newPatient),
        BillingCode(code: "99204", wrvu: 2.60, description: "New Patient - High (45-59 min)", category: .newPatient),
        BillingCode(code: "99205", wrvu: 3.50, description: "New Patient - Very High (60-74 min)", category: .newPatient),

        // Preventive Visits - New Patient
        BillingCode(code: "99381", wrvu: 1.50, description: "Preventive New (< 1 year)", category: .preventiveNew),
        BillingCode(code: "99382", wrvu: 1.50, description: "Preventive New (1-4 years)", category: .preventiveNew),
        BillingCode(code: "99383", wrvu: 1.50, description: "Preventive New (5-11 years)", category: .preventiveNew),
        BillingCode(code: "99384", wrvu: 1.50, description: "Preventive New (12-17 years)", category: .preventiveNew),
        BillingCode(code: "99385", wrvu: 2.00, description: "Preventive New (18-39 years)", category: .preventiveNew),

        // Preventive Visits - Established Patient
        BillingCode(code: "99391", wrvu: 1.37, description: "Preventive Est. (< 1 year)", category: .preventiveEstablished),
        BillingCode(code: "99392", wrvu: 1.37, description: "Preventive Est. (1-4 years)", category: .preventiveEstablished),
        BillingCode(code: "99393", wrvu: 1.37, description: "Preventive Est. (5-11 years)", category: .preventiveEstablished),
        BillingCode(code: "99394", wrvu: 1.37, description: "Preventive Est. (12-17 years)", category: .preventiveEstablished),
        BillingCode(code: "99395", wrvu: 1.75, description: "Preventive Est. (18-39 years)", category: .preventiveEstablished),

        // Additional Common Codes
        BillingCode(code: "99211", wrvu: 0.18, description: "Nurse Visit", category: .established),
        BillingCode(code: "90471", wrvu: 0.17, description: "Immunization Admin (first)", category: .modifier),
        BillingCode(code: "90472", wrvu: 0.15, description: "Immunization Admin (each additional)", category: .modifier),
        BillingCode(code: "96127", wrvu: 0.22, description: "Brief Emotional/Behavioral Assessment", category: .modifier),
        BillingCode(code: "99024", wrvu: 0.0, description: "Postop Follow-up", category: .modifier),
        BillingCode(code: "99429", wrvu: 0.61, description: "Unlisted Preventive Service", category: .modifier),
        BillingCode(code: "25", wrvu: 0.0, description: "Modifier 25 (Significant, separately identifiable E/M)", category: .modifier),
    ]

    private var lookup: [String: BillingCode] = [:]

    init() {
        for code in allCodes {
            lookup[code.code] = code
        }
    }

    func getWRVU(for code: String) -> Double {
        return lookup[code]?.wrvu ?? 0.0
    }

    func getCode(_ code: String) -> BillingCode? {
        return lookup[code]
    }

    func calculateTotalWRVU(for codes: [String]) -> Double {
        return codes.reduce(0.0) { sum, code in
            sum + getWRVU(for: code)
        }
    }

    func codesByCategory(_ category: BillingCode.CodeCategory) -> [BillingCode] {
        return allCodes.filter { $0.category == category }
    }

    func suggestedCodesForDuration(_ seconds: Int, visitType: String) -> [String] {
        let minutes = seconds / 60

        if visitType == "Well" {
            // Suggest preventive codes based on typical age ranges
            return ["99391", "99392", "99393", "99394"]
        }

        // Sick visits - suggest based on duration
        if minutes < 15 {
            return ["99212"]
        } else if minutes < 25 {
            return ["99213"]
        } else if minutes < 35 {
            return ["99214"]
        } else {
            return ["99215"]
        }
    }
}
