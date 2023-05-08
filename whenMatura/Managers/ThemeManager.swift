//
//  ThemeManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI
import WidgetKit

class ThemeManager: ObservableObject {
    
    @Published var current = Theme.defaultTheme
    
    let defaultThemes: [Theme] = [.defaultTheme, .proTheme]
    let colorThemes: [Theme] = [.blue, .red, .yellow, .orange, .indigo, .green, .brown, .pink, .purple, .walut, .lavender]
    let altThemes: [Theme] = [.blueAlt, .redAlt, .yellowAlt, .orangeAlt, .indigoAlt, .greenAlt, .brownAlt, .pinkAlt, .purpleAlt, .walutAlt, .lavenderAlt]
    
    @Published var userTheme = Theme(name: "Użytkownika", primary: .black, background: .white)
    
    static let shared = ThemeManager()
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")!
    
    init() {
        let themeCode = defaults.integer(forKey: "themeCode")
        updateUserTheme()
        current = decodeTheme(from: themeCode)
    }
    
    func decodeTheme(from code: Int) -> Theme {
        switch code {
        case 0 ..< 100:
            let index = code
            return defaultThemes[index]
        case 100 ..< 200:
            let index = code % 100
            return colorThemes[index]
        case 200 ..< 300:
            let index = code % 200
            return altThemes[index]
        case 1000:
            return userTheme
        default:
            return .defaultTheme
        }
    }
    
    private func codeTheme(_ theme: Theme) -> Int {
        if defaultThemes.contains(where: { $0 == theme }) {
            let code = defaultThemes.firstIndex(of: theme)!
            return code
        } else if colorThemes.contains(where: { $0 == theme }) {
            let code = 100 + colorThemes.firstIndex(of: theme)!
            return code
        } else if altThemes.contains(where: { $0 == theme }) {
            let code = 200 + altThemes.firstIndex(of: theme)!
            return code
        } else if theme == userTheme {
            return 1000
        } else {
            return 0
        }
    }
    
    func setTheme(_ theme: Theme) {
        defaults.set(codeTheme(theme), forKey: "themeCode")
        defaults.synchronize()
        DispatchQueue.main.async {
            self.current = theme
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "whenMaturaWidget")
    }
    
    func updateUserTheme() {
        var primaryColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        var secondaryColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        var backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        if let primaryComponents = defaults.array(forKey: "customThemePrimary") as? [CGFloat] {
            primaryColor = CGColor(red: primaryComponents[0], green: primaryComponents[1], blue: primaryComponents[2], alpha: primaryComponents[3])
        }
        
        if let secondaryComponents = defaults.array(forKey: "customThemeSecondary") as? [CGFloat] {
            secondaryColor = CGColor(red: secondaryComponents[0], green: secondaryComponents[1], blue: secondaryComponents[2], alpha: secondaryComponents[3])
        }
        
        if let backgroundComponents = defaults.array(forKey: "customThemeBackground") as? [CGFloat] {
            backgroundColor = CGColor(red: backgroundComponents[0], green: backgroundComponents[1], blue: backgroundComponents[2], alpha: backgroundComponents[3])
        }
        
        let useSecondary = defaults.bool(forKey: "customThemeUseSecondary")
        
        if useSecondary {
            userTheme = Theme(name: "Użytkownika", primary: Color(primaryColor), secondary: Color(secondaryColor), background: Color(backgroundColor))
        } else {
            userTheme = Theme(name: "Użytkownika", primary: Color(primaryColor), background: Color(backgroundColor))
        }
        
        if defaults.integer(forKey: "themeCode") == 1000 {
            setTheme(userTheme)
        }
        
        print("User theme updated!")
    }
    
}

struct Theme: Hashable, Identifiable {
    
    let name: String
    
    let primary: Color
    let secondary: Color
    let background: Color
    
    var preview: some View {
        HStack(spacing: 0) {
            if background == .systemBackground {
                background
                primary
            } else if name == "Pro" {
                LinearGradient.pro
            } else {
                background
            }
        }
        .frame(width: 40, height: 40)
        .cornerRadius(20)
        .padding(2)
        .background {
            Color.primary
                .clipShape(Circle())
        }
    }
    
    let id = UUID()
    
    init(name: String, primary: Color, secondary: Color, background: Color) {
        self.name = name
        
        self.primary = primary
        self.secondary = secondary
        self.background = background
    }
    
    init(name: String, primary: Color, background: Color) {
        self.name = name
        
        self.primary = primary
        self.secondary = primary.opacity(0.6)
        self.background = background
    }
    
    static let defaultTheme = Theme(name: "Domyślny", primary: .primary, secondary: .gray, background: .systemBackground)
    static let proTheme = Theme(name: "Pro", primary: .white, background: .white)
    
    static let blue = Theme(name: "Niebieski", primary: .white, background: .blue)
    static let red = Theme(name: "Czerwony", primary: .white, background: .red)
    static let yellow = Theme(name: "Żółty", primary: .black, background: .yellow)
    static let orange = Theme(name: "Pomarańczowy", primary: .black, background: .orange)
    static let indigo = Theme(name: "Indygo", primary: .white, background: .indigo)
    static let green = Theme(name: "Zielony", primary: .white, background: .green)
    static let brown = Theme(name: "Brązowy", primary: .white, background: .brown)
    static let pink = Theme(name: "Różowy", primary: .black, background: .lightPink)
    static let purple = Theme(name: "Fioletowy", primary: .white, background: .purple)
    static let walut = Theme(name: "Walutowy", primary: .white, background: .walut)
    static let lavender = Theme(name: "Lawendowy", primary: .white, background: .lavender)
    
    static let blueAlt = Theme(name: "Niebieski Alternatywny", primary: .blue, background: .systemBackground)
    static let redAlt = Theme(name: "Czerwony Alternatywny", primary: .red, background: .systemBackground)
    static let yellowAlt = Theme(name: "Żółty Alternatywny", primary: .yellow, background: .systemBackground)
    static let orangeAlt = Theme(name: "Pomarańczowy Alternatywny", primary: .orange, background: .systemBackground)
    static let indigoAlt = Theme(name: "Indygo Alternatywny", primary: .indigo, background: .systemBackground)
    static let greenAlt = Theme(name: "Zielony Alternatywny", primary: .green, background: .systemBackground)
    static let brownAlt = Theme(name: "Brązowy Alternatywny", primary: .brown, background: .systemBackground)
    static let pinkAlt = Theme(name: "Różowy Alternatywny", primary: .lightPink, background: .systemBackground)
    static let purpleAlt = Theme(name: "Fioletowy Alternatywny", primary: .purple, background: .systemBackground)
    static let walutAlt = Theme(name: "Walutowy Alternatywny", primary: .walut, background: .systemBackground)
    static let lavenderAlt = Theme(name: "Lawendowy Alternatywny", primary: .lavender, background: .systemBackground)
}

extension Color {
    static let systemBackground: Color = Color(uiColor: .systemBackground)
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
    static let lightPink = Color(red: 1, green: 0.78, blue: 0.87)
    static let lavender = Color(red: 0.75, green: 0.6, blue: 0.9)
}

extension LinearGradient {
    static let pro: LinearGradient = LinearGradient(colors: [.blue, .indigo, .purple], startPoint: .bottomLeading, endPoint: .topTrailing)
}
