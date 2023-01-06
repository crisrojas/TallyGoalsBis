import SwiftUI

struct DeleteGoalUseCase: UseCase {
    
    enum Request { case delete(GoalPO, of: BehaviourPO) }
    enum Response { case didDelete(GoalPO, of: BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: RequestType) {
        if case .delete(let goal, of: let behaviour) = request {
            store.update(.delete(.goal(goal, of: behaviour)))
            respond(.didDelete(goal, of: behaviour))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
