import SwiftUI

struct ArchiveBehaviourUseCase: UseCase {
    
    enum Request {
        case archive(BehaviourPO)
        case unarchive(BehaviourPO)
    }
    
    enum Response {
        case didArchive(BehaviourPO)
        case didUnarchive(BehaviourPO)
    }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        switch request {
        case .archive(let item): 
            store.update(.archiveBehaviour(item))
            respond(.didArchive(item))
        case .unarchive(let item):
            store.update(.unarchiveBehaviour(item))
            respond(.didUnarchive(item))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
