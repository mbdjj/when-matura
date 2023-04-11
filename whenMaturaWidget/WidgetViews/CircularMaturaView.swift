//
//  CircularMaturaView.swift
//  whenMaturaWidgetExtension
//
//  Created by Marcin Bartminski on 11/04/2023.
//

import SwiftUI

struct CircularMaturaView: View {
    
    let date: Date
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
    
    var maturaDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let dateString = defaults?.string(forKey: "maturaDate") {
            return Calendar.current.startOfDay(for: formatter.date(from: dateString)!)
        } else {
            return nil
        }
    }
    var startDate: Date? {
        if let startYear = defaults?.integer(forKey: "startYear") {
            var date = Calendar.current.date(from: DateComponents(year: startYear, month: 5, day: 4))!
            if date.dayNumberOfWeek() == 7 {
                date = Calendar.current.date(byAdding: .day, value: 2, to: date)!
            } else if date.dayNumberOfWeek() == 1 {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
            return Calendar.current.startOfDay(for: date)
        } else {
            return nil
        }
    }
    var todayBeginning: Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    var matura: MaturaManager { MaturaManager(maturaDate: maturaDate, startDate: startDate, todayBeginning: todayBeginning) }
    
    var body: some View {
        Gauge(value: matura.percent) {
            Text("\(matura.currentState != .none ? String(matura.days) : "XX")")
        }
        .gaugeStyle(.accessoryCircularCapacity)
    }
}

struct CircularMaturaView_Previews: PreviewProvider {
    static var previews: some View {
        CircularMaturaView(date: .now)
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
