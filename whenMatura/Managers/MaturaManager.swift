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
    @Binding var endDate: Date
    
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
            return MaturaTexts(top: "\(polishLeft(days)) Ci", bottom: "\(polishDay(days)) do matury")
        case .inBetween:
            return MaturaTexts(top: "Aktualnie jesteś", bottom: "\(polishDay(days)) w trakcie matury")
        case .after:
            return MaturaTexts(top: "Jesteś już", bottom: "\(polishDay(days)) po maturze")
        }
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func polishDay(_ count: Int) -> String {
        if count == 1 {
            return "dzień"
        } else {
            return "dni"
        }
    }
    func polishLeft(_ count: Int) -> String {
        if count == 1 {
            return "Pozostał"
        } else if count > 1 && count < 5 {
            return "Pozostały"
        } else {
            return "Pozostało"
        }
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
