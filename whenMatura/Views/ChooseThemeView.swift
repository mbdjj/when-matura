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
        ScrollView {
            
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
            
            Spacer(minLength: 24)
            
            VStack {
                HStack {
                    Text("DOMYŚLNE")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                    ForEach(ThemeManager.shared.defaultThemes) { theme in
                        Button {
                            withAnimation {
                                manager.setTheme(theme)
                            }
                        } label: {
                            theme.preview
                        }
                    }
                }
            }
            
            Spacer(minLength: 24)
            
            VStack {
                HStack {
                    Text("KOLOROWE")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                    ForEach(ThemeManager.shared.colorThemes) { theme in
                        Button {
                            withAnimation {
                                manager.setTheme(theme)
                            }
                        } label: {
                            theme.preview
                        }
                    }
                }
            }
            
            Spacer(minLength: 24)
            
            VStack {
                HStack {
                    Text("ALTERNATYWNE")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .center), count: 4)) {
                    ForEach(ThemeManager.shared.altThemes) { theme in
                        Button {
                            withAnimation {
                                manager.setTheme(theme)
                            }
                        } label: {
                            theme.preview
                        }
                    }
                }
            }
            
            Spacer(minLength: 24)
            
        }
        .navigationTitle("Motywy")
    }
}

struct ChooseThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseThemeView()
    }
}
