//
//  RectagularMaturaView.swift
//  whenMaturaWidgetExtension
//
//  Created by Marcin Bartminski on 14/04/2023.
//

import SwiftUI

struct RectagularMaturaView: View {
    
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
            HStack(alignment: .center) {
                Text("\(matura.days)")
                    .font(.system(size: 36, design: .rounded))
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                Text(matura.texts.bottom)
                    .font(.system(size: 14, design: .rounded))
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.6)
            }
        }
        .gaugeStyle(.accessoryLinearCapacity)
    }
}

struct RectagularMaturaView_Previews: PreviewProvider {
    static var previews: some View {
        RectagularMaturaView(date: .now)
    }
}
