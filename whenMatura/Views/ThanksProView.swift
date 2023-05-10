//
//  ThanksProView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 10/05/2023.
//

import SwiftUI

struct ThanksProView: View {
    var body: some View {
        ZStack {
            LinearGradient.pro
                .ignoresSafeArea()
            
            VStack {
                Text("Dziękujemy za wsparcie")
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .padding(32)
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
    }
}

struct ThanksProView_Previews: PreviewProvider {
    static var previews: some View {
        ThanksProView()
    }
}
