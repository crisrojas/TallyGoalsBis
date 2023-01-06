import SwiftUI

struct DeleteBehaviourUseCase: UseCase {
    enum Request { case delete(BehaviourPO) }
    enum Response { case wasDeleted(BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
    
    func request(_ request: Request) {
        switch request {
            case .delete(let item): 
            store.update(.delete(.behaviour(item)))
            respond(.wasDeleted(item))
        }
    }
}
