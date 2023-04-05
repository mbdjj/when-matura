//
//  ThemeCreatorView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 05/04/2023.
//

import SwiftUI

struct ThemeCreatorView: View {
    
    @State var primaryColor: CGColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
    @State var secondaryColor: CGColor = .init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    @State var backgroundColor: CGColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
    
    @State var useSecondary: Bool = false
    
    var createdTheme: Theme {
        if !useSecondary {
            return Theme(name: "Użytkownika", primary: Color(primaryColor), background: Color(backgroundColor))
        } else {
            return Theme(name: "Użytkownika", primary: Color(primaryColor), secondary: Color(secondaryColor), background: Color(backgroundColor))
        }
    }
    
    var body: some View {
        ScrollView {
            ThemePreview(theme: createdTheme)
            
            ColorPicker(selection: $primaryColor) {
                Text("Kolor tekstu podstawowy")
            }
            .padding(.horizontal)
            
            if useSecondary {
                ColorPicker(selection: $secondaryColor) {
                    Text("Kolor tekstu drugorzędny")
                }
                .padding(.horizontal)
            }
            
            ColorPicker(selection: $backgroundColor) {
                Text("Kolor tła")
            }
            .padding(.horizontal)
            
            Toggle("Używaj dwóch kolorów tekstu", isOn: $useSecondary)
                .padding()
            
        }
        .navigationTitle("Kreator motywów")
        .animation(.easeInOut, value: useSecondary)
    }
}

struct ThemeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ThemeCreatorView()
        }
    }
}
