//
//  AppStateManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 20/03/2023.
//

import Foundation

class AppStateManager: ObservableObject {
    
    @Published var appState: AppState
    let defaults = UserDefaults.standard
    static let shared = AppStateManager()
    
    init() {
        let onboardingDone = defaults.bool(forKey: "onboardingDone")
        appState = onboardingDone ? .app : .onboarding
    }
    
}

enum AppState {
    case onboarding
    case app
}
