import SwiftUI

final class ViewState: ObservableObject {
    
    @Published var behaviours = [BehaviourPO]()
    @Published var presetState: AppState.PresetsState = .idle
    @Published var selectedTab = Tab.goals
    
    var goals: [GoalVO] {
        behaviours
            .map { behaviour in 
                Array(behaviour.goals).map { goal in
                    GoalVO(
                        id: goal.id,
                        behaviour: behaviour,
                        goal: goal,
                        value: goal.value,
                        progress: goal.entries.count
                    )
                }  
            }
            .flatMap { $0 }
            .sorted(by: { $0.goal.isPinned && !$1.goal.isPinned })
    }
    
    var uncompletedGoals: [GoalVO] { goals.filter({ !$0.completed }) }
    var completedGoals: [GoalVO] { goals.filter({ $0.completed }) }
    var archivedBehaviours: [BehaviourPO] { behaviours.filter({ $0.isArchived }) }
    var unarchivedBehavious: [BehaviourPO] { 
        behaviours.filter({ !$0.isArchived })
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.emoji < $1.emoji })
            .sorted(by: { $0.isPinned && !$1.isPinned })
        
    }
    
    init(store: StateStore) {
        store.callback { self.process(appState: store.state()) }
        self.process(appState: store.state())
    }
    
    func handle(msg: Message) {
        if case .presets(.response(.error)) = msg {  presetState = .error }
    }
    
    func process(appState: AppState) { 
        behaviours = appState.behaviours
        presetState = appState.presetsState
    }
}
