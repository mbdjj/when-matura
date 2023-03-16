//
//  ContentView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 16/03/2023.
//

import SwiftUI

struct CountView: View {
    var body: some View {
        VStack {
            Text("\(420)")
                .font(.system(size: 180, weight: .semibold, design: .rounded))
                .minimumScaleFactor(0.6)
            Text("dni do matury")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct CountViewPreviews: PreviewProvider {
    static var previews: some View {
        CountView()
    }
}
