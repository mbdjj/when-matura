//
//  SettingsView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI
import WidgetKit
import AlertToast
import StoreKit

struct SettingsView: View {
    
    @AppStorage("name", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var name: String = "User"
    @AppStorage("startYear", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var startYear: Int = 2020
    @AppStorage("endYear", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var endYear: Int = 2025
    
    @AppStorage("presentToast") var showToast: Bool = false
    @AppStorage("toastTitle") var toastTitle: String = "Działa"
    
    @State var changeName = ""
    @State var changeStartYear: Int? = nil
    @State var changeEndYear: Int? = nil
    
    @FocusState var nameFocused
    @FocusState var startYearFocused
    @FocusState var endYearFocused
    
    @State var showProView: Bool = false
    
    @Environment(\.requestReview) var requestReview
    
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
            
            Section {
                Button {
                    showProView = true
                } label: {
                    Label {
                        Text("Ulepsz do Pro")
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(LinearGradient.pro)
                    }
                }
            } header: {
                Text("Pro")
            }
            
            Section {
                Button {
                    requestReview()
                } label: {
                    Label("Oceń aplikację", systemImage: "star")
                }
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
        .sheet(isPresented: $showProView) {
            PurchaseProView()
        }
    }
    
    func savePressed() {
        unfocusFields()
        
        DispatchQueue.main.async {
            self.saveInfo()
        }
    }
    
    func saveInfo() {
        let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")
        if changeName != "" {
            name = changeName
            changeName = ""
        }
        if changeStartYear != nil {
            startYear = changeStartYear!
            changeStartYear = nil
            
            defaults?.synchronize()
            WidgetCenter.shared.reloadTimelines(ofKind: "whenMaturaWidget")
        }
        if changeEndYear != nil {
            endYear = changeEndYear!
            changeEndYear = nil
            
            defaults?.set(maturaDate(for: endYear), forKey: "maturaDate")
            defaults?.synchronize()
            WidgetCenter.shared.reloadTimelines(ofKind: "whenMaturaWidget")
        }
        
        toastTitle = "Zapisano informacje"
        showToast = true
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
