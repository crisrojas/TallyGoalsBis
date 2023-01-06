import SwiftUI

struct HandleBehaviourCountUseCase: UseCase {
    enum Request {
        case increase(BehaviourPO)
        case decrease(BehaviourPO)
    }
    
    enum Response {
        case didIncrease(BehaviourPO)
        case didDecrease(BehaviourPO)
    }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        switch request {
            case .increase(let behaviour): 
            store.update(.increaseBehaviour(behaviour))
            respond(.didIncrease(behaviour))
            case .decrease(let behaviour):
            store.update(.decreaseBehaviour(behaviour))
            respond(.didDecrease(behaviour))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
