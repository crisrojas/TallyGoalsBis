import SwiftUI

#warning("@todo. Separation of concerns: Create & use business objects instead of persistency ones: GoalPO vs GoalBO, BehaviourPO vs BehaviourBO && EntityPO vs EntityBO")
#warning("@todo. createTutorialFeature")
typealias AppCore = Input
func createAppCore(
    store: StateStore,
    receivers: [Input],
    rootHandler: @escaping Output
) -> AppCore {
    
    store.callback { print("Update") }
    
    let presetsGateway = PresetsService()
    
    let features = [
        createBehaviourListFeature(store: store, output: rootHandler),
        createGoalListFeature(store: store, output: rootHandler),
        createPresetListFeature(presetsGateway: presetsGateway, store: store, output: rootHandler)
    ]
    
    let appComponents = receivers + features
    
    return { msg in appComponents.forEach { $0(msg)} }
}
