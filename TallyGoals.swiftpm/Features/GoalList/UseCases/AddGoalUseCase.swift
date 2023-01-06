import SwiftUI

struct AddGoalUseCase: UseCase {
    enum Request { case add(GoalPO, to: BehaviourPO) }
    enum Response { case didAdd(GoalPO, to: BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        if case .add(let goal, let behaviour) = request { 
            store.update(.add(.goal(goal, toBehaviour: behaviour)))
            respond(.didAdd(goal, to: behaviour))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
