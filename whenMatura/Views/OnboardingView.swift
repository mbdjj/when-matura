//
//  OnboardingView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var selectedView = 0
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")!
    
    // Name
    @State var name = ""
    @FocusState var nameFieldFocused: Bool
    
    // Start year
    @State var startYear = 0
    var startYearText: String {
        if startYear != 0 {
            let len = "\(startYear)".count
            let count = 4 - len > 0 ? 4 - len : 0
            return "\(startYear)\(repeat: "R", count)"
        } else {
            return "RRRR"
        }
    }
    @FocusState var startYearFocused: Bool
    
    // End year
    @State var endYear = 0
    var endYearText: String {
        if endYear != 0 {
            let len = "\(endYear)".count
            let count = 4 - len > 0 ? 4 - len : 0
            return "\(endYear)\(repeat: "R", count)"
        } else {
            return "RRRR"
        }
    }
    @FocusState var endYearFocused: Bool
    
    var body: some View {
        TabView(selection: $selectedView) {
            VStack {
                Text(name.isEmpty ? "Cześć!" : "Cześć \(name)!")
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        nameFieldFocused = true
                    }
                Text("Wprowadź swoje imię.")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        nameFieldFocused = true
                    }
                
                TextField("Name", text: $name)
                    .opacity(0)
                    .focused($nameFieldFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .onAppear {
                        nameFieldFocused = true
                    }
                    .onSubmit {
                        if name.isEmpty {
                            nameFieldFocused = true
                        } else {
                            withAnimation {
                                selectedView = 1
                            }
                        }
                    }
                
                Button {
                    if name.isEmpty {
                        nameFieldFocused = true
                    } else {
                        withAnimation {
                            selectedView = 1
                        }
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.primary)
                }
            }
            .tag(0)
            
            VStack {
                Text("W którym roku zacząłeś / zaczęłaś?")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        startYearFocused = true
                    }
                Text(startYearText)
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        startYearFocused = true
                    }
                
                TextField("Start Year", value: $startYear, format: .number)
                    .opacity(0)
                    .focused($startYearFocused)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .onAppear {
                        startYearFocused = true
                    }
                    .onSubmit {
                        if startYear != 0 && "\(startYear)".count > 3 {
                            startYearFocused = true
                        } else {
                            selectedView = 2
                        }
                    }
                
                Button {
                    if startYear <= 0 || "\(startYear)".count < 4 {
                        startYearFocused = true
                    } else {
                        withAnimation {
                            selectedView = 2
                        }
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.primary)
                }
            }
            .tag(1)
            
            VStack {
                Text("W którym roku kończysz szkołę??")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        endYearFocused = true
                    }
                Text(endYearText)
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        endYearFocused = true
                    }
                
                TextField("End Year", value: $endYear, format: .number)
                    .opacity(0)
                    .focused($endYearFocused)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .onAppear {
                        endYearFocused = true
                    }
                    .onSubmit {
                        if endYear != 0 && "\(startYear)".count > 3 {
                            endYearFocused = true
                        } else {
                            selectedView = 2
                        }
                    }
                
                Button {
                    if endYear <= 0 || "\(endYear)".count < 4 {
                        endYearFocused = true
                    } else {
                        withAnimation {
                            finishOnboarding()
                        }
                    }
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.primary)
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    func finishOnboarding() {
        defaults.set(name, forKey: "name")
        defaults.set(startYear, forKey: "startYear")
        defaults.set(endYear, forKey: "endYear")
        
        defaults.set(maturaDate(for: endYear), forKey: "maturaDate")
        
        defaults.set(true, forKey: "onboardingDone")
        defaults.synchronize()
        
        Task {
            await IAPManager.shared.updateProStatus()
        }
        
        DispatchQueue.main.async {
            AppStateManager.shared.appState = .app
        }
    }
    
    func maturaDate(for year: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var date = Calendar.current.date(from: DateComponents(year: year, month: 5, day: 4))!
        if date.dayNumberOfWeek() == 7 {
            date = Calendar.current.date(byAdding: .day, value: 2, to: date)!
        } else if date.dayNumberOfWeek() == 1 {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        print(formatter.string(from: date))
        return formatter.string(from: date)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
