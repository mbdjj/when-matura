//
//  SettingsView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("name") var name: String = "User"
    
    var body: some View {
        List {
            Label(name, systemImage: "person.fill")
            
            NavigationLink {
                ChooseThemeView()
            } label: {
                Label("Motyw", systemImage: "paintpalette.fill")
            }

        }
        .navigationTitle("Ustawienia")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
