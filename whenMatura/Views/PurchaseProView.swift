//
//  PurchaseProView.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 08/05/2023.
//

import SwiftUI

struct PurchaseProView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var iap = IAPManager.shared
    
    let featureList = [
        ProFeature("Motywy aplikacji", subtitle: "Odblokuj motywy przygotowane specjalnie przez nas."),
        ProFeature("Kreator motywów", subtitle: "Stwórz swój własny motyw, dokładnie taki jaki lubisz."),
        ProFeature("Motywy widżetów", subtitle: "Te same motywy zarówno w aplikacji jak i na widżetach"),
        ProFeature("Specjalny motyw Pro"),
        ProFeature("Wsparcie naszej pracy")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Ulepsz do Pro")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    Text("Odblokuj całą funkcjonalność aplikacji")
                        .font(.system(.title3, design: .rounded, weight: .regular))
                }
                .padding(.vertical)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.linearGradient(colors: [.blue, .indigo, .purple], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .padding(.bottom)
                
                VStack {
                    Text("Co zyskujesz:")
                        .font(.system(.title3, design: .rounded, weight: .regular))
                        .padding(.horizontal)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray)
                        }
                    
                    VStack {
                        ForEach(featureList) { feature in
                            ProFeatuteCell(feature: feature)
                        }
                    }
                    Text("")
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray)
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                        .background {
                            Color(uiColor: .secondarySystemBackground)
                                .clipShape(Circle())
                        }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !iap.isPro {
                    ZStack {
                        let disableButton = iap.isLoading || iap.isPurchasing
                        Button {
                            guard let product = iap.products.first else { return }
                            Task {
                                try await iap.purchase(product)
                            }
                        } label: {
                            Text("Ulepsz - \(iap.products.first?.displayPrice ?? "")")
                                .font(.system(.title2, design: .rounded, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background {
                                    LinearGradient.pro
                                }
                                .cornerRadius(25)
                                .padding()
                        }
                        .disabled(disableButton)
                        .opacity(disableButton ? 0.7 : 1.0)
                        
                        if disableButton {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .frame(height: 70)
                    .background(.regularMaterial)
                }
            }
        }
    }
}

struct PurchaseProView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseProView()
    }
}
