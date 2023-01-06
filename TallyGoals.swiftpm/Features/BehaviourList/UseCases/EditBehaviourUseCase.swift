import SwiftUI

struct EditBehaviourUseCase: UseCase {
    
    enum Request { case edit(emoji: String, title: String, of: BehaviourPO) }
    enum Response { case didEdit(BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        if case .edit(let emoji, let title, let item) = request {
            store.update(.edit(emoji: emoji, name: title, of: item))
            respond(.didEdit(item))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void 
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
