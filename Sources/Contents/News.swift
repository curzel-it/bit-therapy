import SwiftUI
import Taku

struct NewsView: View {
    var body: some View {
        TakuView(
            token: TakuService.shared.token,
            userId: TakuService.shared.userId
        )
    }
}

class TakuService {
    static let shared = TakuService()

    fileprivate var token: String = ""
    fileprivate var userId: String = ""

    private init() {
        userId = "0"
        token = getToken() ?? ""
    }

    private func getToken() -> String? {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let props = try? NSDictionary(contentsOf: url, error: ()),
            let token = props["TakuToken"] as? String else { return nil }
        return token
    }

    func isAvailable() -> Bool {
        return AppState.global.isDevApp && token != ""
    }
}
