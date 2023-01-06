import SwiftUI

struct ReadPresetsUseCase: UseCase {
    
    enum Request { case read }
    enum Response { 
        case didRead
        case error(_Error)
        
        enum _Error: Error {
            case fileNotFound
            case decodingError
        }
    }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        if case .read = request { 
            do {
                let presets = try presetsGateway.read()
                store.update(.setPresets(presets))
                respond(.didRead)
            } 
            catch is Response._Error { respond(.error(.fileNotFound)) }
            catch { respond(.error(.decodingError)) ; print(error.localizedDescription) }
        }
    }
    
    let presetsGateway: PresetsGateway
    let store: StateStore
    let respond: (Response) -> Void
    
    init(presetsGateway: PresetsGateway, store: StateStore, responder: @escaping (Response) -> Void) {
        self.presetsGateway = presetsGateway
        self.store = store
        self.respond = responder
    }
}

protocol PresetsGateway { func read() throws -> [PresetCategory] }

final class PresetsService: PresetsGateway {
    
    func read() throws -> [PresetCategory] {
        if let path = Bundle.main.path(forResource: "presets", ofType: "json") {
            let presets = try jsonDecoder.decode(PresetsResponse.self, from: try Data(contentsOf: URL(fileURLWithPath: path)))
            return presets.categories
        }
        
        throw ReadPresetsUseCase.Response._Error.fileNotFound
    }
}

#warning("@todo: use everywhere")
let jsonDecoder: JSONDecoder = { return JSONDecoder() }()
