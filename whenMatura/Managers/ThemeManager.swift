//
//  ThemeManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI

class ThemeManager: ObservableObject {
    
    @Published var current = Theme.indigo
    
    let defaultThemes: [Theme] = [.defaultTheme]
    let colorThemes: [Theme] = [.blue, .red, .yellow, .orange, .indigo]
    let altThemes: [Theme] = [.blueAlt, .redAlt, .yellowAlt, .orangeAlt, .indigoAlt]
    
    static let shared = ThemeManager()
    
}

struct Theme: Hashable {
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
    
    init(primary: Color, secondary: Color, background: Color) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
    }
    
    init(primary: Color, background: Color) {
        self.primary = primary
        self.secondary = primary.opacity(0.6)
        self.background = background
    }
    
    static let defaultTheme = Theme(primary: .primary, secondary: .gray, background: .systemBackground)
    
    static let blue = Theme(primary: .white, background: .blue)
    static let red = Theme(primary: .white, background: .red)
    static let yellow = Theme(primary: .black, background: .yellow)
    static let orange = Theme(primary: .black, background: .orange)
    static let indigo = Theme(primary: .white, background: .indigo)
    
    static let blueAlt = Theme(primary: .blue, background: .systemBackground)
    static let redAlt = Theme(primary: .red, background: .systemBackground)
    static let yellowAlt = Theme(primary: .yellow, background: .systemBackground)
    static let orangeAlt = Theme(primary: .orange, background: .systemBackground)
    static let indigoAlt = Theme(primary: .indigo, background: .systemBackground)
}

extension Color {
    static let systemBackground: Color = Color(uiColor: .systemBackground)
}
