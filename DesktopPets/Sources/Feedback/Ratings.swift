import Squanch
import StoreKit
import SwiftUI
import SystemConfiguration

public class RatingsService {
    var store: RatingsStore
    var requester: RatingsRequester
    let launchesBeforeAskingForReview: Int
    let maxRequestsPerVersion: Int
    
    public convenience init(
        launchesBeforeAskingForReview: Int = 5,
        maxRequestsPerVersion: Int = 1
    ) {
        self.init(
            store: RatingsUserDefaults(),
            requester: StoreKitRatings(),
            launchesBeforeAskingForReview: launchesBeforeAskingForReview,
            maxRequestsPerVersion: maxRequestsPerVersion
        )
    }
    
    init(
        store: RatingsStore,
        requester: RatingsRequester,
        launchesBeforeAskingForReview: Int = 5,
        maxRequestsPerVersion: Int = 1
    ) {
        self.store = store
        self.requester = requester
        self.launchesBeforeAskingForReview = launchesBeforeAskingForReview
        self.maxRequestsPerVersion = maxRequestsPerVersion
    }
    
    public func askForRatingIfNeeded() {
        guard canAskForRating() else { return }
        printDebug("Ratings", "Asking for ratings...")
        store.requests += 1
        requester.askForRating()
    }
    
    func canAskForRating() -> Bool {
        appLaunched(withVersion: AppInfo.version ?? "")
        
        guard store.launches >= launchesBeforeAskingForReview else {
            let missingLaunches = launchesBeforeAskingForReview - store.launches
            printDebug("Ratings", "\(missingLaunches) more launches required before rate request...")
            return false
        }
        guard store.requests < maxRequestsPerVersion else {
            printDebug("Ratings", "Skipping request, already asked \(store.requests) times...")
            return false
        }
        return true
    }
    
    private func appLaunched(withVersion currentVersion: String) {
        if store.version != currentVersion {
            store.version = currentVersion
            store.requests = 0
            store.launches = 0
        }
        store.launches += 1
    }
}

protocol RatingsRequester {
    func askForRating()
}

protocol RatingsStore {
    var launches: Int { get set }
    var requests: Int { get set }
    var version: String { get set }
}

private struct StoreKitRatings: RatingsRequester {
    func askForRating() {
        SKStoreReviewController.requestReview()
    }
}
        
private struct RatingsUserDefaults: RatingsStore {
    private var defaults: UserDefaults? { UserDefaults(suiteName: "Ratings") }
    
    var launches: Int {
        get { defaults?.integer(forKey: "launches") ?? 0 }
        set { defaults?.set(newValue, forKey: "launches") }
    }
    
    var requests: Int {
        get { defaults?.integer(forKey: "requests") ?? 0 }
        set { defaults?.set(newValue, forKey: "requests") }
    }
    
    var version: String {
        get { defaults?.string(forKey: "version") ?? "" }
        set { defaults?.set(newValue, forKey: "version") }
    }
}
