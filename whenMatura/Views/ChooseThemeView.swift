//
//  ChooseThemeView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 21/03/2023.
//

import SwiftUI

struct ChooseThemeView: View {
    
    @ObservedObject var manager = ThemeManager.shared
    
    var body: some View {
        VStack {
            
            let selected = manager.current
            VStack {
                Text("Podgląd motywu")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(selected.primary)
                Text("\(Int.random(in: 1 ... 1000))")
                    .font(.system(size: 100, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(selected.primary)
                Text("To liczba, która się wylosowała")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(selected.secondary)
            }
            .padding(24)
            .background {
                selected.background
                    .cornerRadius(16)
            }
            .padding(2)
            .background {
                Color.primary
                    .cornerRadius(18)
            }
            .padding(8)
            .minimumScaleFactor(0.6)
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                ForEach(ThemeManager.shared.defaultThemes, id: \.self) { theme in
                    Button {
                        withAnimation {
                            ThemeManager.shared.current = theme
                        }
                    } label: {
                        theme.preview
                    }
                }
            }
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                ForEach(ThemeManager.shared.colorThemes, id: \.self) { theme in
                    Button {
                        withAnimation {
                            ThemeManager.shared.current = theme
                        }
                    } label: {
                        theme.preview
                    }
                }
            }
            
            Spacer()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                ForEach(ThemeManager.shared.altThemes, id: \.self) { theme in
                    Button {
                        withAnimation {
                            ThemeManager.shared.current = theme
                        }
                    } label: {
                        theme.preview
                    }
                }
            }
            
            Spacer()
            
        }
    }
}

struct ChooseThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseThemeView()
    }
}
