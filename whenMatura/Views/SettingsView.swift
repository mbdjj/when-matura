//
//  SettingsView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    
    @AppStorage("name", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var name: String = "User"
    @AppStorage("startYear", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var startYear: Int = 2020
    @AppStorage("endYear", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var endYear: Int = 2025
    
    @State var changeName = ""
    @State var changeStartYear: Int? = nil
    @State var changeEndYear: Int? = nil
    
    @FocusState var nameFocused
    @FocusState var startYearFocused
    @FocusState var endYearFocused
    
    var disableSave: Bool {
        changeName == "" && changeStartYear == nil && changeEndYear == nil
    }
    
    var body: some View {
        List {
            Section {
                TextField(name, text: $changeName)
                    .focused($nameFocused)
                
                TextField("Rok rozpoczęcia: \(String(startYear))", value: $changeStartYear, format: .number)
                    .keyboardType(.numberPad)
                    .focused($startYearFocused)
                
                TextField("Rok matury: \(String(endYear))", value: $changeEndYear, format: .number)
                    .keyboardType(.numberPad)
                    .focused($endYearFocused)
            } header: {
                Text("Dane użytkownika")
            }
            
            Section {
                
                NavigationLink {
                    ChooseThemeView()
                } label: {
                    Label("Motyw", systemImage: "paintpalette.fill")
                }
                
                NavigationLink {
                    ThemeCreatorView()
                } label: {
                    Label("Kreator motywów", systemImage: "paintbrush.fill")
                }
                
            } header: {
                Text("Motywy")
            }
        }
        .navigationTitle("Ustawienia")
        .foregroundColor(.primary)
        .toolbar {
            Button {
                savePressed()
            } label: {
                Text("Zapisz")
                    .bold()
                    .foregroundColor(disableSave ? .gray : .primary)
            }
            .disabled(disableSave)
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    func savePressed() {
        unfocusFields()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.saveInfo()
        }
    }
    
    func saveInfo() {
        if changeName != "" {
            name = changeName
            changeName = ""
        }
        if changeStartYear != nil {
            startYear = changeStartYear!
            changeStartYear = nil
        }
        if changeEndYear != nil {
            endYear = changeEndYear!
            changeEndYear = nil
            
            let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
            defaults?.set(maturaDate(for: endYear), forKey: "maturaDate")
            defaults?.synchronize()
            WidgetCenter.shared.reloadTimelines(ofKind: "whenMaturaWidget")
        }
    }
    
    func unfocusFields() {
        nameFocused = false
        startYearFocused = false
        endYearFocused = false
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
