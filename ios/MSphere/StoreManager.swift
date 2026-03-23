import StoreKit

/// Manages StoreKit 2 In-App Purchases for M-Sphere
/// - Auto-Renewable Subscription: unlocks unlimited meditation timer
/// - Non-Consumable "Dein Ich": unlocks personalized 3D model generation (max 5)
@MainActor
final class StoreManager: ObservableObject {

    // Product IDs
    static let subscriptionID = "de.jochenhornung.msphere.standard"
    static let deinIchID = "de.jochenhornung.msphere.deinich"

    // Dein Ich generation limit
    static let deinIchMaxGenerations = 5
    private static let deinIchUsedKey = "msphere_deinich_generations_used"

    @Published private(set) var isSubscribed = false
    @Published private(set) var deinIchUnlocked = false
    @Published private(set) var deinIchGenerationsUsed: Int = 0
    @Published private(set) var products: [Product] = []

    var deinIchGenerationsRemaining: Int {
        guard deinIchUnlocked else { return 0 }
        return max(0, Self.deinIchMaxGenerations - deinIchGenerationsUsed)
    }

    private var transactionListener: Task<Void, Error>?

    init() {
        deinIchGenerationsUsed = UserDefaults.standard.integer(forKey: Self.deinIchUsedKey)
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
        Task { await updateEntitlements() }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.subscriptionID, Self.deinIchID])
            NSLog("[StoreManager] Loaded \(products.count) products: \(products.map { $0.id })")
        } catch {
            NSLog("[StoreManager] Failed to load products: \(error)")
        }
    }

    // MARK: - Purchase

    func purchase(_ productID: String) async -> Bool {
        guard let product = products.first(where: { $0.id == productID }) else {
            #if DEBUG
            NSLog("[StoreManager] DEBUG: Product \(productID) not found, granting for free")
            if productID == Self.subscriptionID { isSubscribed = true }
            if productID == Self.deinIchID { deinIchUnlocked = true }
            return true
            #else
            NSLog("[StoreManager] Product not found: \(productID)")
            return false
            #endif
        }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try Self.checkVerified(verification)
                await transaction.finish()
                await updateEntitlements()
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

    // MARK: - Dein Ich Generation Counter

    func useDeinIchGeneration() {
        deinIchGenerationsUsed += 1
        UserDefaults.standard.set(deinIchGenerationsUsed, forKey: Self.deinIchUsedKey)
    }

    // MARK: - Restore

    func restorePurchases() async {
        try? await AppStore.sync()
        await updateEntitlements()
    }

    // MARK: - Entitlements

    func updateEntitlements() async {
        var subscribed = false
        var deinIch = false

        for await result in Transaction.currentEntitlements {
            if let transaction = try? Self.checkVerified(result) {
                switch transaction.productID {
                case Self.subscriptionID:
                    subscribed = true
                case Self.deinIchID:
                    deinIch = true
                default:
                    break
                }
            }
        }

        isSubscribed = subscribed
        deinIchUnlocked = deinIch
        deinIchGenerationsUsed = UserDefaults.standard.integer(forKey: Self.deinIchUsedKey)
        NSLog("[StoreManager] Entitlements: subscribed=\(subscribed), deinIch=\(deinIch), generations=\(deinIchGenerationsUsed)/\(Self.deinIchMaxGenerations)")
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                let transaction = try? Self.checkVerified(result)
                if let transaction {
                    await self?.updateEntitlements()
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
