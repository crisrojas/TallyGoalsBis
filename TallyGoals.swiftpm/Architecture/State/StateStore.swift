import SwiftUI

typealias Access = () -> AppState
typealias Update = (AppState.Update...) -> ()
typealias Reset = () -> ()
typealias Callback = (@escaping () -> ()) -> ()

typealias StateStore = (
    state: Access,
    update: Update,
    reset: Reset,
    callback: Callback
)

func createStore(
    pathInDocuments: String = "state.json", 
    fileManager: FileManager = .default
) -> StateStore {
    
    var state = readAppState(from: pathInDocuments, fileManager: fileManager) {
        didSet { callbacks.forEach { $0() }}
    }
    
    var callbacks = [() -> Void]()
    
    return ( 
        state: { state },
        update: { 
            state = state.reduce(with: $0)
            write(state: state, to: pathInDocuments, fileManager: fileManager)
        }, 
        reset: { 
            state = AppState()
            write(state: state, to: pathInDocuments, fileManager: fileManager)
        },
        callback: { callbacks.append($0) }
    )
}


private func write(
    state: AppState,
    to pathInDocuments: String,
    fileManager: FileManager
) {
    
    do {
        let encoder = JSONEncoder()
        
#if DEBUG
        encoder.outputFormatting = .prettyPrinted
#endif
        
        let data = try encoder.encode(state)
        try data.write(to: fileURL(pathInDocuments: pathInDocuments, fileManager: fileManager))
    } catch {
        print(error)
    }
}

private func readAppState(
    from pathInDocuments: String,
    fileManager: FileManager
) -> AppState {
    do {
        return try JSONDecoder()
            .decode(AppState.self, from: try Data(contentsOf: fileURL(pathInDocuments: pathInDocuments, fileManager: fileManager)))
    } catch {
        print("Failure when trying to read state:")
        print(error)
    }
    
    return AppState()
}

private func fileURL(
    pathInDocuments: String,
    fileManager: FileManager
) throws -> URL {
    try fileManager
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(pathInDocuments)
}
