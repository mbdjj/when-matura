//
//  MaturaManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 04/04/2023.
//

import SwiftUI

struct MaturaManager {
    
    @Binding var startDate: Date
    @Binding var todayBeginning: Date
    
    var endDate: Date {
        let date = Calendar.current.date(byAdding: .day, value: 19, to: startDate)!
        return Calendar.current.startOfDay(for: date)
    }
    
    var currentState: MaturaState {
        let startOfToday = Calendar.current.startOfDay(for: todayBeginning)
        if daysBetween(start: startOfToday, end: startDate) > 0 {
            return .before
        } else if daysBetween(start: startDate, end: startOfToday) >= 0 && daysBetween(start: startOfToday, end: endDate) >= 0 {
            return .inBetween
        } else {
            return .after
        }
    }
    
    var days: Int {
        let startOfToday = Calendar.current.startOfDay(for: todayBeginning)
        switch currentState {
        case .before:
            return daysBetween(start: startOfToday, end: startDate)
        case .inBetween:
            return daysBetween(start: startDate, end: startOfToday) + 1
        case .after:
            return daysBetween(start: endDate, end: startOfToday)
        }
    }
    
    var texts: MaturaTexts {
        switch currentState {
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
    case before
    case inBetween
    case after
}

struct MaturaTexts {
    let top: String
    let bottom: String
}
