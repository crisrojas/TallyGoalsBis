import SwiftUI

func createBehaviourListFeature
(store: StateStore, output: @escaping Output) -> Input {
    
    let adder = AddBehaviourUseCase(store: store, responder: handle(output: output))
    let deleter = DeleteBehaviourUseCase(store: store, responder: handle(output: output))
    let countHandler = HandleBehaviourCountUseCase(store: store, responder: handle(output: output))
    let pinner = PinBehaviourUseCase(store: store, responder: handle(output: output))
    let archiver = ArchiveBehaviourUseCase(store: store, responder: handle(output: output))
    let editer = EditBehaviourUseCase(store: store, responder: handle(output: output))
    
    return { msg in 
        if case .behaviour(.add(let item)) = msg { adder.request(.add(item)) }
        if case .behaviour(.delete(let item)) = msg { deleter.request(.delete(item)) }
        if case .behaviour(.increase(let item)) = msg { countHandler.request(.increase(item)) }
        if case .behaviour(.decrease(let item)) = msg { countHandler.request(.decrease(item)) }
        if case .behaviour(.pin(let item)) = msg { pinner.request(.pin(item)) }
        if case .behaviour(.unpin(let item)) = msg { pinner.request(.unpin(item)) }
        if case .behaviour(.toggleArchive(let item)) = msg {
            if item.isArchived { archiver.request(.unarchive(item)) }
            else { archiver.request(.archive(item)) }
        }
        if case .behaviour(.archive(let item)) = msg { archiver.request(.archive(item)) }
        if case .behaviour(.unarchive(let item)) = msg { archiver.request(.unarchive(item)) }
        if case .behaviour(.edit(let emoji, let title, let item)) = msg { editer.request(.edit(emoji: emoji, title: title, of: item))}
    }
}

private func handle(output: @escaping Output) -> (AddBehaviourUseCase.Response) -> Void {
    { if case .wasAdded(let item) = $0 { output(.behaviour(.response(.wasAdded(item)))) }}
}

private func handle(output: @escaping Output) -> (DeleteBehaviourUseCase.Response) -> Void {
    { if case .wasDeleted(let item) = $0 { output(.behaviour(.response(.wasDeleted(item)))) } }
}

private func handle(output: @escaping Output) -> (HandleBehaviourCountUseCase.Response) -> Void {
    return { response in 
        switch response {
            case .didDecrease(let item): output(.behaviour(.response(.didIncrease(item))))
            case .didIncrease(let item): output(.behaviour(.response(.didDecrease(item))))
        }
    }
}

private func handle(output: @escaping Output) -> (PinBehaviourUseCase.Response) -> Void {
    return { response in 
        switch response {
            case .didPin(let item): output(.behaviour(.response(.didPin(item))))
            case .didUnpin(let item): output(.behaviour(.response(.didUnpin(item))))
        }
    }
}

private func handle(output: @escaping Output) -> (ArchiveBehaviourUseCase.Response) -> Void {
    return { response in 
        switch response {
            case .didArchive(let item): output(.behaviour(.response(.didArchive(item))))
            case .didUnarchive(let item): output(.behaviour(.response(.didUnarchive(item))))
        }
    }
}

private func handle(output: @escaping Output) -> (EditBehaviourUseCase.Response) -> Void {
    { if case .didEdit(let item) = $0 { output(.behaviour(.response(.didEdit(item)))) } }
}
