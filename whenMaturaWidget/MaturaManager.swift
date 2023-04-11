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
    
    var maturaEndDate: Date {
        let date = Calendar.current.date(byAdding: .day, value: 19, to: maturaDate ?? .now)!
        return Calendar.current.startOfDay(for: date)
    }
    
    var currentState: MaturaState {
        let startOfToday = Calendar.current.startOfDay(for: todayBeginning)
        if let maturaDate, startDate != nil {
            if daysBetween(start: startOfToday, end: maturaDate) > 0 {
                return .before
            } else if daysBetween(start: maturaDate, end: startOfToday) >= 0 && daysBetween(start: startOfToday, end: maturaEndDate) >= 0 {
                return .inBetween
            } else {
                return .after
            }
        } else {
            return .none
        }
    }
    
    var days: Int {
        let startOfToday = Calendar.current.startOfDay(for: todayBeginning)
        switch currentState {
        case .none:
            return 0
        case .before:
            return daysBetween(start: startOfToday, end: maturaDate!)
        case .inBetween:
            return daysBetween(start: maturaDate!, end: startOfToday)
        case .after:
            return daysBetween(start: maturaEndDate, end: startOfToday)
        }
    }
    
    var percent: Double {
        let startOfToday = Calendar.current.startOfDay(for: todayBeginning)
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
