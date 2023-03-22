//
//  ContentView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct CountView: View {
    
    @AppStorage("name") var name: String = "User"
    @AppStorage("maturaDate") var text: String = "2069-05-04"
    
    @State var shouldShowSettings: Bool = false
    
    var maturaDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return Calendar.current.startOfDay(for: formatter.date(from: text)!)
    }
    var todayBeginning: Date {
        return Calendar.current.startOfDay(for: .now)
    }
    
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationStack {
            let theme = themeManager.current
            ZStack {
                theme.background
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Text("Cześć \(name)!")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(theme.primary)
                    Text("Pozostało Ci")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundColor(theme.secondary)
                    
                    Text("\(daysBetween(start: todayBeginning, end: maturaDate))")
                        .font(.system(size: 180, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(theme.primary)
                    Text("dni do matury")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundColor(theme.secondary)
                    
                    Spacer()
                    Spacer()
                }
                .padding()
                .toolbar {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(theme.primary)
                    }
                }
            }
        }
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
