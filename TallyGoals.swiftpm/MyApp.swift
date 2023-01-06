import SwiftUI

@main
final class MyApp: App {
    
    private let store = createStore()
    private lazy var viewState = ViewState(store: store)
    private lazy var rootHandler: AppCore = createAppCore(
        store: store,
        receivers: [viewState.handle(msg:)], 
        rootHandler: { self.rootHandler($0) }
    )
    
    var body: some Scene {
        WindowGroup { Tabbar(viewState: self.viewState, rootHandler: rootHandler) }
    }
}

#warning("@todo: use isEmoji property")
extension Character {
    var isEmoji: Bool {
        self.unicodeScalars
            .map { $0.properties.isEmoji }
            .reduce(false, { $0 || $1 })
    }
}
