import SwiftUI

func createGoalListFeature(store: StateStore, output: @escaping Output) -> Feature {
    
    let adder = AddGoalUseCase(store: store, responder: handle(output: output))
    let deleter = DeleteGoalUseCase(store: store, responder: handle(output: output))
    let increaser = IncreaseGoalUseCase(store: store, responder: handle(output: output))
    let pinner = PinGoalUseCase(store: store, responder: handle(output: output))
    
    return { msg in 
        if case .goal(.add(let goal, let behaviour)) = msg { adder.request(.add(goal, to: behaviour)) }
        if case .goal(.increase(let goal, of: let behaviour)) = msg { increaser.request(.increase(goal, of: behaviour)) }
        if case .goal(.pin(let goal, of: let behaviour)) = msg { print("pin") ;pinner.request(.pin(goal, of: behaviour)) }
        if case .goal(.unpin(let goal, of: let behaviour)) = msg { pinner.request(.unpin(goal, of: behaviour)) }
        if case .goal(.delete(let goal, of: let behaviour)) = msg { deleter.request(.delete(goal, of: behaviour)) }
    }
}

private func handle(output: @escaping Output) -> (AddGoalUseCase.Response) -> Void {
    return { msg in 
        if case .didAdd(let goal, let behaviour) = msg { output(.goal(.response(.didAdd(goal, to: behaviour)))) }
    }
}

private func handle(output: @escaping Output) -> (IncreaseGoalUseCase.Response) -> Void {
    return { msg in 
        if case .didIncrease(let goal, let behaviour) = msg { output(.goal(.response(.didIncrease(goal, of: behaviour))))}
    }
}

private func handle(output: @escaping Output) -> (PinGoalUseCase.Response) -> Void {
    return { msg in 
        if case .didPin(let goal, let behaviour) = msg { output(.goal(.response(.didPin(goal, of: behaviour)))) }
        if case .didUnpin(let goal, let behaviour) = msg { output(.goal(.response(.didUnpin(goal, of: behaviour))))}
    }
}

private func handle(output: @escaping Output) -> (DeleteGoalUseCase.Response) -> Void {
    return { msg in
        if case .didDelete(let goal, let behaviour) = msg { output(.goal(.response(.didDelete(goal, of: behaviour))))}
    }
}
