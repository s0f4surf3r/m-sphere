import StoreKit

/// Manages StoreKit 2 In-App Purchases for M-Sphere "Dein Ich"
/// Consumable: Each purchase grants 2 generation credits
@MainActor
final class StoreManager: ObservableObject {

    static let deinIchProductID = "de.jochenhornung.msphere.deinich.2x"
    static let creditsPerPurchase = 2

    private static let usedCreditsKey = "msphere_deinich_used"

    @Published private(set) var credits: Int = 0
    @Published private(set) var products: [Product] = []

    private var transactionListener: Task<Void, Error>?

    init() {
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
        Task { await recalculateCredits() }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.deinIchProductID])
            NSLog("[StoreManager] Loaded \(products.count) products: \(products.map { $0.id })")
        } catch {
            NSLog("[StoreManager] Failed to load products: \(error)")
        }
    }

    // MARK: - Purchase

    func purchaseDeinIch() async -> Bool {
        guard let product = products.first(where: { $0.id == Self.deinIchProductID }) else {
            #if DEBUG
            // Debug: StoreKit Testing-Config nicht geladen → Credits direkt vergeben
            NSLog("[StoreManager] DEBUG: Product not found, granting \(Self.creditsPerPurchase) free credits")
            let used = UserDefaults.standard.integer(forKey: Self.usedCreditsKey)
            let fakeTotal = (used + credits) / Self.creditsPerPurchase + 1
            credits = fakeTotal * Self.creditsPerPurchase - used
            return true
            #else
            NSLog("[StoreManager] Product not found")
            return false
            #endif
        }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try Self.checkVerified(verification)
                await transaction.finish()
                await recalculateCredits()
                return true
            case .userCancelled:
                return false
            case .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            NSLog("[StoreManager] Purchase error: \(error)")
            return false
        }
    }

    // MARK: - Use Credit

    func useCredit() {
        let used = UserDefaults.standard.integer(forKey: Self.usedCreditsKey)
        UserDefaults.standard.set(used + 1, forKey: Self.usedCreditsKey)
        credits = max(0, credits - 1)
    }

    // MARK: - Restore

    func restorePurchases() async {
        try? await AppStore.sync()
        await recalculateCredits()
    }

    // MARK: - Credit Calculation

    /// Credits = (total purchases × creditsPerPurchase) - used generations
    /// Purchases are counted from Transaction.all (survives reinstall)
    /// Used generations are in UserDefaults (reset on reinstall = user gets credits back)
    func recalculateCredits() async {
        var totalPurchased = 0
        for await result in Transaction.all {
            if let transaction = try? Self.checkVerified(result),
               transaction.productID == Self.deinIchProductID {
                totalPurchased += 1
            }
        }
        let totalCredits = totalPurchased * Self.creditsPerPurchase
        let used = UserDefaults.standard.integer(forKey: Self.usedCreditsKey)
        credits = max(0, totalCredits - used)
        NSLog("[StoreManager] Credits: \(credits) (purchased: \(totalPurchased)×\(Self.creditsPerPurchase)=\(totalCredits), used: \(used))")
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                let transaction = try? Self.checkVerified(result)
                if let transaction {
                    await self?.recalculateCredits()
                    await transaction.finish()
                }
            }
        }
    }

    // MARK: - Verification

    private nonisolated static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let value):
            return value
        }
    }
}
