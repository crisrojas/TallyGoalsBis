import SwiftUI

func createPresetListFeature(presetsGateway: PresetsGateway, store: StateStore, output: @escaping Output) -> Input {
    let reader = ReadPresetsUseCase(presetsGateway: presetsGateway, store: store, responder: handle(output: output))
    return { if case .presets(.read) = $0 { reader.request(.read) } }
}

private func handle(output: @escaping Output) -> (ReadPresetsUseCase.Response) -> Void {
    return { response in
        switch response {
            case .didRead: output(.presets(.response(.didRead)))
            case .error(let error): output(.presets(.response(.error)))
        }
    }
}
