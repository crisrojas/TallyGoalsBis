import SwiftUI

struct PinGoalUseCase: UseCase {
    
    enum Request {
        case pin(GoalPO, of: BehaviourPO)
        case unpin(GoalPO, of: BehaviourPO)
    }
    
    enum Response {
        case didPin(GoalPO, of: BehaviourPO)
        case didUnpin(GoalPO, of: BehaviourPO)
    }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: RequestType) {
        switch request {
            case .pin(let goal, of: let behaviour):
            store.update(.pin(.goal(goal, of: behaviour)))
            respond(.didPin(goal, of: behaviour))
            case .unpin(let goal, of: let behaviour):
            store.update(.unpin(.goal(goal, of: behaviour)))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void 
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
