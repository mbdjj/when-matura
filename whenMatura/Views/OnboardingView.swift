//
//  OnboardingView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var selectedView = 0
    
    // Name
    @State var name = ""
    @FocusState var nameFieldFocused: Bool
    
    // Start year
    @State var startYear = 0
    var startYearText: String {
        if startYear != 0 {
            let len = "\(startYear)".count
            let count = 4 - len > 0 ? 4 - len : 0
            return "\(startYear)\(repeat: "R", count)"
        } else {
            return "RRRR"
        }
    }
    @FocusState var startYearFocused: Bool
    
    var body: some View {
        TabView(selection: $selectedView) {
            VStack {
                Text(name.isEmpty ? "Cześć!" : "Cześć \(name)!")
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        nameFieldFocused = true
                    }
                Text("Wprowadź swoje imię.")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        nameFieldFocused = true
                    }
                
                TextField("Name", text: $name)
                    .opacity(0)
                    .focused($nameFieldFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .onAppear {
                        nameFieldFocused = true
                    }
                    .onSubmit {
                        if name.isEmpty {
                            nameFieldFocused = true
                        } else {
                            selectedView = 1
                        }
                    }
            }
            .tag(0)
            
            VStack {
                Text("W którym roku zacząłeś / zaczęłaś?")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        startYearFocused = true
                    }
                Text(startYearText)
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        startYearFocused = true
                    }
                
                TextField("Start Year", value: $startYear, format: .number)
                    .opacity(0)
                    .focused($startYearFocused)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .onAppear {
                        startYearFocused = true
                    }
                    .onSubmit {
                        if startYear != 0 && "\(startYear)".count > 3 {
                            nameFieldFocused = true
                        } else {
                            selectedView = 1
                        }
                    }
            }
            .tag(1)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
}
