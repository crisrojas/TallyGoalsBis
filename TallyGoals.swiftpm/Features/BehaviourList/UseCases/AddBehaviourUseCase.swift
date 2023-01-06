import SwiftUI

struct AddBehaviourUseCase: UseCase {
    
    enum Request { case add(BehaviourPO) }
    enum Response { case wasAdded(BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    private let store: StateStore
    private let responder: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.responder = responder
    }
    
    func request(_ request: Request) {
        switch request {
        case .add(let item):
            store.update(.add(.behaviour(item)))
            responder(.wasAdded(item))
        }
    }
}
