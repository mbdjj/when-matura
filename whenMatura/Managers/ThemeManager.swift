//
//  ThemeManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI

class ThemeManager: ObservableObject {
    
    @Published var current = Theme.blueAlt
    
    let themes: [Theme] = [.defaultTheme, .blue, .blueAlt]
    
    static let shared = ThemeManager()
    
}

struct Theme: Hashable {
    let primary: Color
    let secondary: Color
    let background: Color
    
    var preview: some View {
        HStack {
            if background == .init(uiColor: .systemBackground) {
                background
                primary
            } else {
                background
            }
        }
    }
    
    init(primary: Color, secondary: Color, background: Color) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
    }
    
    init(primary: Color, background: Color) {
        self.primary = primary
        self.secondary = primary.opacity(0.9)
        self.background = background
    }
    
    static let defaultTheme = Theme(primary: .primary, secondary: .gray, background: .systemBackground)
    static let blue = Theme(primary: .white, background: .blue)
    static let blueAlt = Theme(primary: .blue, background: .systemBackground)
}

extension Color {
    static let systemBackground: Color = Color(uiColor: .systemBackground)
}
