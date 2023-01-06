import SwiftUI

struct PinBehaviourUseCase: UseCase {
    
    enum Request {
        case pin(BehaviourPO)
        case unpin(BehaviourPO)
    }
    
    enum Response {
        case didPin(BehaviourPO)
        case didUnpin(BehaviourPO)
    }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        switch request {
            case .pin(let behaviour):
            store.update(.pin(.behaviour(behaviour)))
            respond(.didPin(behaviour))
            case .unpin(let behaviour):
            store.update(.unpin(.behaviour(behaviour)))
            respond(.didUnpin(behaviour))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
} 
