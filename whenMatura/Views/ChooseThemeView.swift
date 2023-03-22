//
//  ChooseThemeView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI

struct ChooseThemeView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 3)) {
            ForEach(ThemeManager.shared.themes, id: \.self) { theme in
                Button {
                    ThemeManager.shared.current = theme
                } label: {
                    theme.preview
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct ChooseThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseThemeView()
    }
}
