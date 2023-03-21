//
//  ContentView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct CountView: View {
    
    @AppStorage("name") var name: String = "User"
    
    var maturaDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let text = UserDefaults.standard.string(forKey: "maturaDate") ??  "2069-01-01"
        
        return Calendar.current.startOfDay(for: formatter.date(from: text)!)
    }
    var todayBeginning: Date {
        return Calendar.current.startOfDay(for: .now)
    }
    
    var body: some View {
        VStack {
            
            Text("Cześć \(name)!")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
            Text("Pozostało Ci")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
            
            Text("\(daysBetween(start: todayBeginning, end: maturaDate))")
                .font(.system(size: 180, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text("dni do matury")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}

struct CountViewPreviews: PreviewProvider {
    static var previews: some View {
        CountView()
    }
}
