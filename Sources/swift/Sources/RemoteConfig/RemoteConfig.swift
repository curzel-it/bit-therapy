import BareBones
import Combine
import Foundation
import SwiftUI

protocol RemoteConfigProvider {
    func fetch()
    func current() -> AppRemoteConfig
    func config() -> AnyPublisher<AppRemoteConfig, Never>
}

struct AppRemoteConfig: Codable {
    let disabledPets: [String]
}

class RemoteConfigFromGitHubRepo: RemoteConfigProvider {
    private var client = HttpClient(baseUrl: "https://raw.githubusercontent.com/curzel-it/curzel-it.github.io/master")

    private lazy var lastConfig = CurrentValueSubject<AppRemoteConfig, Never>(AppRemoteConfig(disabledPets: []))

    func config() -> AnyPublisher<AppRemoteConfig, Never> {
        lastConfig
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func current() -> AppRemoteConfig {
        lastConfig.value
    }

    func fetch() {
        Task {
            let response: AppRemoteConfig? = try? await client.get(from: "pets.json").unwrap()
            let config = response ?? lastConfig.value
            lastConfig.send(config)
        }
    }
}
