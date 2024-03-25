//
//  MaturaManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 04/04/2023.
//

import SwiftUI

struct MaturaManager {
    
    let maturaDate: Date?
    let startDate: Date?
    let todayBeginning: Date
    let maturaEndDate: Date?
    
    var currentState: MaturaState {
        if let maturaDate, let startDate, let maturaEndDate {
            if daysBetween(start: todayBeginning, end: maturaDate) > 0 {
                return .before
            } else if daysBetween(start: maturaDate, end: todayBeginning) >= 0 && daysBetween(start: todayBeginning, end: maturaEndDate) >= 0 {
                return .inBetween
            } else {
                return .after
            }
        } else {
            return .none
        }
    }
    
    var days: Int {
        switch currentState {
        case .none:
            return 0
        case .before:
            return daysBetween(start: todayBeginning, end: maturaDate!)
        case .inBetween:
            return daysBetween(start: maturaDate!, end: todayBeginning) + 1
        case .after:
            return daysBetween(start: maturaEndDate!, end: todayBeginning)
        }
    }
    
    var percent: Double {
        switch currentState {
        case .none:
            return 0
        case .before:
            let allDays = daysBetween(start: startDate!, end: maturaDate!)
            let days = daysBetween(start: startDate!, end: todayBeginning)
            return Double(days) / Double(allDays)
        default:
            return 1
        }
    }
    
    var texts: MaturaTexts {
        switch currentState {
        case .none:
            return MaturaTexts(top: "", bottom: "Uzupełnij w aplikacji")
        case .before:
            return MaturaTexts(top: "Pozostało Ci", bottom: "dni do matury")
        case .inBetween:
            return MaturaTexts(top: "Aktualnie jesteś", bottom: "dni w trakcie matury")
        case .after:
            return MaturaTexts(top: "Jesteś już", bottom: "dni po maturze")
        }
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
}

enum MaturaState {
    case none
    case before
    case inBetween
    case after
}

struct MaturaTexts {
    let top: String
    let bottom: String
}
