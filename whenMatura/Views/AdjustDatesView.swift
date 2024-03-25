//
//  AdjustDatesView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 08/08/2023.
//

import SwiftUI

struct AdjustDatesView: View {
    
    @AppStorage("maturaDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var maturaDateString: String = "2023-08-08"
    @AppStorage("endDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var endDateString: String = "2023-08-09"
    
    @State var maturaDate: Date = .now
    @State var endDate: Date = .now
    @State private var refresh = false
    
    var body: some View {
        List {
            Section("Data rozpoczęcia matury") {
                DatePicker("Data" + (refresh ? "" : " "), selection: $maturaDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            
            Section("Dzień ostatniej matury") {
                DatePicker("Data" + (refresh ? "" : " "), selection: $endDate, displayedComponents: .date)
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
                endDate = formatter.date(from: endDateString) ?? .distantFuture
                refresh.toggle()
            }
        }
    }
    
    func saveDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        maturaDateString = formatter.string(from: maturaDate)
        endDateString = formatter.string(from: endDate)
    }
}

struct AdjustDatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdjustDatesView()
        }
    }
}
