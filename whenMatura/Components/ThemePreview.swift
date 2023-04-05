//
//  ThemePreview.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 05/04/2023.
//

import SwiftUI

struct ThemePreview: View {
    
    let theme: Theme
    
    var body: some View {
        VStack {
            Text("Podgląd motywu")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(theme.primary)
            Text("\(Int.random(in: 1 ... 1000))")
                .font(.system(size: 100, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundColor(theme.primary)
            Text(theme.name)
                .font(.system(.title3, design: .rounded))
                .bold()
                .foregroundColor(theme.secondary)
        }
        .padding(24)
        .background {
            theme.background
                .cornerRadius(16)
        }
        .padding(2)
        .background {
            Color.primary
                .cornerRadius(18)
        }
        .padding(8)
        .minimumScaleFactor(0.6)
    }
}

struct ThemePreview_Previews: PreviewProvider {
    static var previews: some View {
        ThemePreview(theme: .defaultTheme)
    }
}
