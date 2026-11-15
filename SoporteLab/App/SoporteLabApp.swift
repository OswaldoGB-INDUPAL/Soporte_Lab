import SwiftUI

@main
struct SoporteLabApp: App {
    private let result: Result<AppContainer, Error>

    @MainActor
    init() {
        let storage: StorageKind = ProcessInfo.processInfo.arguments.contains("-inMemory") ? .inMemory : AppContainer.storage
        result = Result { try AppContainer(storage: storage) }
    }

    var body: some Scene {
        WindowGroup {
            switch result {
            case .success(let container):
                RootTabView(container: container)
            case .failure(let error):
                ContentUnavailableView("No se pudo abrir SoporteLab", systemImage: "exclamationmark.triangle",
                                       description: Text(error.localizedDescription))
            }
        }
    }
}
