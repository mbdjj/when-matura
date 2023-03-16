//
//  OnboardingView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var name = ""
    
    @FocusState var nameFieldFocused: Bool
    
    
    var body: some View {
        TabView {
            VStack {
                Text(name.isEmpty ? "Cześć!" : "Cześć \(name)!")
                    .font(.system(.title, design: .rounded, weight: .semibold))
                    .onTapGesture {
                        nameFieldFocused = true
                    }
                Text("Wprowadź swoje imię.")
                    .foregroundColor(.gray)
                
                TextField("Name", text: $name)
                    .opacity(0)
                    .focused($nameFieldFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
            }
            .tag(0)
        }
        .tabViewStyle(.page)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
