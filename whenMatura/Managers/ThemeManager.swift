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
    
    let defaultThemes: [Theme] = [.defaultTheme]
    let colorThemes: [Theme] = [.blue, .red, .yellow, .orange, .indigo, .green, .brown, .pink, .purple, .walut]
    let altThemes: [Theme] = [.blueAlt, .redAlt, .yellowAlt, .orangeAlt, .indigoAlt, .greenAlt, .brownAlt, .pinkAlt, .purpleAlt, .walutAlt]
    
    static let shared = ThemeManager()
    let defaults = UserDefaults(suiteName: "group.ga.bartminski.whenMatura")!
    
    init() {
        let themeCode = defaults.integer(forKey: "themeCode")
        current = decodeTheme(from: themeCode)
    }
    
    func decodeTheme(from code: Int) -> Theme {
        switch code {
        case 0:
            return .defaultTheme
        case 100 ..< 200:
            let index = code % 100
            return colorThemes[index]
        case 200 ..< 300:
            let index = code % 200
            return altThemes[index]
        default:
            return .defaultTheme
        }
    }
    
    private func codeTheme(_ theme: Theme) -> Int {
        if defaultThemes.contains(where: { $0 == theme }) {
            return 0
        } else if colorThemes.contains(where: { $0 == theme }) {
            let code = 100 + colorThemes.firstIndex(of: theme)!
            return code
        } else if altThemes.contains(where: { $0 == theme }) {
            let code = 200 + altThemes.firstIndex(of: theme)!
            return code
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
}

extension Color {
    static let systemBackground: Color = Color(uiColor: .systemBackground)
    static let walut = Color(red: 0, green: 0.725, blue: 0.682)
    static let lightPink = Color(red: 1, green: 0.78, blue: 0.87)
}
