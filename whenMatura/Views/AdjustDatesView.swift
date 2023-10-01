//
//  AdjustDatesView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 08/08/2023.
//

import SwiftUI

struct AdjustDatesView: View {
    
    @AppStorage("maturaDate", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var maturaDateString: String = "2023-08-08"
    
    @State var maturaDate: Date
    
    init(maturaString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        _maturaDate = State(initialValue: formatter.date(from: maturaString) ?? .now)
    }
    
    var body: some View {
        List {
            Section("Data rozpoczęcia matury") {
                DatePicker("Data", selection: $maturaDate, displayedComponents: .date)
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
    }
    
    func saveDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        maturaDateString = formatter.string(from: maturaDate)
    }
}

struct AdjustDatesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdjustDatesView(maturaString: "2023-08-08")
        }
    }
}
