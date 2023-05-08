//
//  ProFeatuteCell.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 08/05/2023.
//

import SwiftUI

struct ProFeatuteCell: View {
    
    let feature: ProFeature
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(feature.title)
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                
                if !feature.subtitle.isEmpty {
                    Text(feature.subtitle)
                        .font(.system(.body, design: .rounded, weight: .regular))
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ProFeatuteCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProFeatuteCell(feature: ProFeature("Motywy aplikacji", subtitle: "Odblokuj motywy przygotowane specjalnie przez nas."))
            ProFeatuteCell(feature: ProFeature("Kreator motywów"))
        }
    }
}

struct ProFeature: Identifiable {
    let id = UUID()
    
    let title: String
    let subtitle: String
    
    init(_ title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    init(_ title: String) {
        self.title = title
        self.subtitle = ""
    }
}
