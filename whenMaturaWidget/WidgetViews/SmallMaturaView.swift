//
//  SmallMaturaView.swift
//  whenMaturaWidgetExtension
//
//  Created by Marcin Bartminski on 11/04/2023.
//

import SwiftUI

struct SmallMaturaView: View {
    let date: Date
    let theme: Theme
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
    let paddingValue: CGFloat
    
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
    var endDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let dateString = defaults?.string(forKey: "endDate") {
            return Calendar.current.startOfDay(for: formatter.date(from: dateString)!)
        } else {
            return nil
        }
    }
    
    var matura: MaturaManager { MaturaManager(maturaDate: maturaDate, startDate: startDate, todayBeginning: todayBeginning, maturaEndDate: endDate) }
    
    init(date: Date, theme: Theme) {
        self.date = date
        self.theme = theme
        if #available(iOS 17, *) {
            paddingValue = 0
        } else {
            paddingValue = 16
        }
    }
    
    var body: some View {
        VStack {
            Text("\(matura.currentState != .none ? String(matura.days) : "XX")")
                .foregroundColor(theme.primary)
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(matura.texts.bottom)
                .foregroundColor(theme.secondary)
                .font(.system(.body, design: .rounded))
                .bold()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(paddingValue)
        .background {
            if theme.name == "Pro" {
                LinearGradient.pro
            } else {
                theme.background
            }
        }
    }
}

struct SmallMaturaView_Previews: PreviewProvider {
    static var previews: some View {
        SmallMaturaView(date: .now, theme: .defaultTheme)
    }
}
