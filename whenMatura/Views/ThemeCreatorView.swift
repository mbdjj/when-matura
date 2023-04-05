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
    
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")!
    
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
        .toolbar {
            Button {
                saveCustomTheme()
            } label: {
                Text("Zapisz")
                    .foregroundColor(.primary)
                    .bold()
            }
        }
        .onAppear {
            withAnimation {
                restoreThemeFromDefaults()
            }
        }
    }
    
    func saveCustomTheme() {
        defaults.set(primaryColor.components, forKey: "customThemePrimary")
        defaults.set(secondaryColor.components, forKey: "customThemeSecondary")
        defaults.set(backgroundColor.components, forKey: "customThemeBackground")
        defaults.set(useSecondary, forKey: "customThemeUseSecondary")
        print("Custom Theme saved!")
        
        ThemeManager.shared.updateUserTheme()
    }
    
    func restoreThemeFromDefaults() {
        if let primaryComponents = defaults.array(forKey: "customThemePrimary") as? [CGFloat] {
            primaryColor = CGColor(red: primaryComponents[0], green: primaryComponents[1], blue: primaryComponents[2], alpha: primaryComponents[3])
        }
        
        if let secondaryComponents = defaults.array(forKey: "customThemeSecondary") as? [CGFloat] {
            secondaryColor = CGColor(red: secondaryComponents[0], green: secondaryComponents[1], blue: secondaryComponents[2], alpha: secondaryComponents[3])
        }
        
        if let backgroundComponents = defaults.array(forKey: "customThemeBackground") as? [CGFloat] {
            backgroundColor = CGColor(red: backgroundComponents[0], green: backgroundComponents[1], blue: backgroundComponents[2], alpha: backgroundComponents[3])
        }
        
        useSecondary = defaults.bool(forKey: "customThemeUseSecondary")
        
        print("Theme loaded!")
    }
}

struct ThemeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ThemeCreatorView()
        }
    }
}
