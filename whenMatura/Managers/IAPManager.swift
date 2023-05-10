//
//  IAPManager.swift
//  whenMatura
//
//  Created by Marcin Bartminski on 10/05/2023.
//

import SwiftUI
import StoreKit

class IAPManager: ObservableObject {
    
    @Published var products =  [Product]()
    @Published var isLoading = false
    @Published var isPurchasing = false
    
    var taskHandle: Task<Void, Error>?
    
    @AppStorage("pro", store: UserDefaults(suiteName: "group.ga.bartminski.whenMatura")) var isPro: Bool = false
    
    static let shared = IAPManager()
    
    init() {
        
        taskHandle = listenForTransactions()
        
        Task.init {
            await requestProducts()
        }
        
    }
    
    func requestProducts() async {
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let products = try await Product.products(for: ["ga.bartminski.whenMatura.proFeatures"])
            
            DispatchQueue.main.async {
                self.products = products
                self.isLoading = false
            }
        } catch {
            print(error)
        }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        DispatchQueue.main.async {
            self.isPurchasing = true
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await updateContent(for: product.id)
            
            await transaction.finish()
            
            DispatchQueue.main.async {
                self.isPurchasing = false
            }
            
            return transaction
        case .pending, .userCancelled:
            DispatchQueue.main.async {
                self.isPurchasing = false
            }
            
            return nil
        default:
            DispatchQueue.main.async {
                self.isPurchasing = false
            }
            
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("Unverified transaction")
            throw StoreKitError.notEntitled
        case .verified(let safe):
            return safe
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updateContent(for: transaction.productID)
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor func updateContent(for productID: String) {
        if productID == "ga.bartminski.whenMatura.proFeatures" {
            isPro = true
        }
    }
    
    func updateProStatus() async {
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                if transaction.productID == "ga.bartminski.whenMatura.proFeatures" {
                    print("Transaction updated successfully!")
                    await updateContent(for: transaction.productID)
                }
            case .unverified(let unverifiedTransaction, let verificationError):
                if unverifiedTransaction.productID == "ga.bartminski.whenMatura.proFeatures" {
                    print(verificationError.localizedDescription)
                    DispatchQueue.main.async {
                        self.isPro = false
                        ThemeManager.shared.setTheme(.defaultTheme)
                    }
                }
            }
        }
    }
    
}
