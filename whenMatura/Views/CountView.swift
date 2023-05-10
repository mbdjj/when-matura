//
//  ContentView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI
import AlertToast

struct CountView: View {
    
    @AppStorage("name", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var name: String = "User"
    @AppStorage("maturaDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var text: String = "2069-05-04"
    
    @AppStorage("presentToast") var showToast: Bool = false
    @AppStorage("toastTitle") var toastTitle: String = "Działa"
    
    @State var shouldShowSettings: Bool = false
    
    @State var maturaDate: Date
    @State var todayBeginning: Date = Calendar.current.startOfDay(for: .now)
    
    @ObservedObject var themeManager = ThemeManager.shared
    var matura: MaturaManager { MaturaManager(startDate: $maturaDate, todayBeginning: $todayBeginning) }
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")!
        let text = defaults.string(forKey: "maturaDate")!
        
        _maturaDate = State(initialValue: Calendar.current.startOfDay(for: formatter.date(from: text)!))
    }
    
    var body: some View {
        NavigationStack {
            let theme = themeManager.current
            ZStack {
                if theme.name == "Pro" {
                    LinearGradient.pro
                        .ignoresSafeArea()
                } else {
                    theme.background
                        .ignoresSafeArea()
                }
                
                VStack {
                    Spacer()
                    
                    Text("Cześć \(name)!")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(theme.primary)
                    Text(matura.texts.top)
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundColor(theme.secondary)
                    
                    Text("\(matura.days)")
                        .font(.system(size: 180, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(theme.primary)
                    Text(matura.texts.bottom)
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
                            .toolbarRole(.editor)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(theme.primary)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            print("Date refreshed!")
            withAnimation {
                todayBeginning = Calendar.current.startOfDay(for: .now)
                Task {
                    await IAPManager.shared.updateProStatus()
                }
            }
        }
        .onChange(of: text) { newValue in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            maturaDate = Calendar.current.startOfDay(for: formatter.date(from: text)!)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .hud, type: .systemImage("checkmark", .green), title: toastTitle)
        }
    }
}

struct CountViewPreviews: PreviewProvider {
    static var previews: some View {
        CountView()
    }
}
