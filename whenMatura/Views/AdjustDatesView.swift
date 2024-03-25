//
//  AdjustDatesView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 08/08/2023.
//

import SwiftUI
import WidgetKit
import AlertToast

struct AdjustDatesView: View {
    
    @AppStorage("maturaDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var maturaDateString: String = "2023-08-08"
    @AppStorage("endDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var endDateString: String = "2023-08-09"
    
    @AppStorage("presentToast") var showToast: Bool = false
    @AppStorage("toastTitle") var toastTitle: String = "Działa"
    
    @State var maturaDate: Date = .now
    @State var previousMaturaDate: Date = .now
    @State var endDate: Date = .now
    @State private var refresh = false
    
    var startOfYear: Date { maturaDate.startOfYear() }
    var endOfYear: Date { maturaDate.endOfYear() }
    
    var body: some View {
        List {
            Section("Data rozpoczęcia matury") {
                DatePicker("Data" + (refresh ? "" : " "), selection: $maturaDate, in: startOfYear ... endOfYear, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            
            Section("Dzień ostatniej matury") {
                DatePicker("Data" + (refresh ? "" : " "), selection: $endDate, in: previousMaturaDate ... endOfYear, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
        .navigationTitle("Dostosuj daty")
        .toolbar {
            Button {
                saveDates()
            } label: {
                Text("Zapisz")
                    .bold()
            }
        }
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            withAnimation {
                maturaDate = formatter.date(from: maturaDateString) ?? .distantPast
                previousMaturaDate = maturaDate
                endDate = formatter.date(from: endDateString) ?? .distantFuture
                refresh.toggle()
            }
        }
        .onChange(of: maturaDate) { newValue in
            withAnimation {
                if newValue.timeIntervalSince1970 > endDate.timeIntervalSince1970 {
                    endDate = maturaDate
                    previousMaturaDate = maturaDate
                }
            }
        }
    }
    
    @MainActor func saveDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        maturaDateString = formatter.string(from: maturaDate)
        endDateString = formatter.string(from: endDate)
        UserDefaults(suiteName: "group.ga.bartminski.whenMatura")?.synchronize()
        WidgetCenter.shared.reloadTimelines(ofKind: "whenMaturaWidget")
        
        toastTitle = "Zapisano informacje"
        showToast = true
    }
}

struct AdjustDatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdjustDatesView()
        }
    }
}
