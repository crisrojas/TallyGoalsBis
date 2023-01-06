import SwiftUI

struct IncreaseGoalUseCase: UseCase {
    
    enum Request { case increase(GoalPO, of: BehaviourPO) }
    enum Response { case didIncrease(GoalPO, of: BehaviourPO) }
    
    typealias RequestType = Request
    typealias ResponseType = Response
    
    func request(_ request: Request) {
        switch request {
            case .increase(let goal, of: let behaviour):
            store.update(.increase(goal, of: behaviour))
            respond(.didIncrease(goal, of: behaviour))
        }
    }
    
    private let store: StateStore
    private let respond: (Response) -> Void
    
    init(store: StateStore, responder: @escaping (Response) -> Void) {
        self.store = store
        self.respond = responder
    }
}
