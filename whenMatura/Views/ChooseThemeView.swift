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
            ThemePreview(theme: selected)
            
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
        NavigationStack {
            ChooseThemeView()
        }
    }
}
