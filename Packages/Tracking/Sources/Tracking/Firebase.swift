import Firebase
import FirebaseAnalytics
import Squanch

extension FirebaseApp {
    
    static func setup() -> Bool {
        if let path = firebasePlistPath(),
           let options = FirebaseOptions.init(contentsOfFile: path) {
            FirebaseApp.configure(options: options)
            return true
        }
        return false
    }
    
    private static func firebasePlistPath() -> String? {
        Bundle.main.path(forResource: "Secrets", ofType: "plist")
    }
}

extension Tracking {
    
    static func logView(_ name: String) {
        log(AnalyticsEventScreenView, with: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: name
        ])
    }
    
    static func log(_ eventName: String, with params: [String: Any] = [:]) {
        let name = eventName.cleaned()
        let bundle: [String: Any] = params.reduce(into: [:]) { partialResult, pair in
            partialResult[pair.key.cleaned()] = pair.value
        }
        if isEnabled {
            Analytics.logEvent(name, parameters: bundle)
        }
        printDebug("Tracking", name, "with", bundle.jsonString())
    }
}
