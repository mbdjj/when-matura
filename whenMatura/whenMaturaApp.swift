//
//  whenMaturaApp.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

@main
struct whenMaturaApp: App {
    
    @ObservedObject var appState = AppStateManager.shared
    
    var body: some Scene {
        WindowGroup {
            switch appState.appState {
            case .onboarding:
                OnboardingView()
            case .app:
                CountView()
            }
        }
    }
}
