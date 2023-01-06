import SwiftUI

struct AppState: Codable { 
    let behaviours: [BehaviourPO]
    let presetsState: PresetsState
    init(behaviours: [BehaviourPO] = [], presetsState: PresetsState = .idle) { 
        self.behaviours = behaviours
        self.presetsState = presetsState
    }
}

// MARK: - AppState Commands
extension AppState {
    
    enum PresetsState: Codable {
        case idle
        case loading
        case success([PresetCategory])
        case error
    }
    
    enum Update {
        case add(Add)
        case delete(Delete)
        case pin(Pin)
        case unpin(Unpin)
        case archiveBehaviour(BehaviourPO)
        case unarchiveBehaviour(BehaviourPO)
        case increase(GoalPO, of: BehaviourPO)
        case increaseBehaviour(BehaviourPO)
        case decreaseBehaviour(BehaviourPO)
        case edit(emoji: String, name: String, of: BehaviourPO)
        case setPresets([PresetCategory])
        
        enum Add {
            case behaviour(BehaviourPO)
            case goal(GoalPO, toBehaviour: BehaviourPO)
        }
        
        enum Delete {
            case behaviour(BehaviourPO)
            case goal(GoalPO, of: BehaviourPO)
        }
        
        enum Pin {
            case behaviour(BehaviourPO)
            case goal(GoalPO, of: BehaviourPO)
        }
        
        enum Unpin {
            case behaviour(BehaviourPO)
            case goal(GoalPO, of: BehaviourPO)
        }
    }
    
    func reduce(with updates: [Update]) -> AppState {
        updates.reduce(self) { $0.update(with: $1) }
    }
    
    func reduce(with updates: Update...) -> AppState {
        updates.reduce(self) { $0.update(with: $1) }
    }
    
    func update(with update: Update) -> AppState {
        switch update {
        case .add(let addCase):
            if case .behaviour(let item) = addCase {
                return AppState(behaviours: behaviours + [item])
            } 
            
            if case .goal(let item, let behaviour) = addCase {
                print("adding goal") 
                let behaviours = behaviours.filter({$0.id != behaviour.id }) + [behaviour.update(.addGoal(item))]
                return AppState(behaviours: behaviours)
            }
        case .delete(let deleteCase):
            if case .behaviour(let item) = deleteCase {
                return AppState(behaviours: behaviours.filter({ $0.id != item.id }))
            }
            
            if case .goal(let item, let behaviour) = deleteCase {
                return AppState(behaviours: behaviours.filter({ $0.id != behaviour.id}) + [behaviour.update(.deleteGoal(item))])
            }
        case .increase(let goal, of: let behaviour):  
            let behaviour = behaviour.update(.increaseGoal(goal))
            let behaviours = behaviours.filter({ $0.id != behaviour.id}) + [behaviour]
            
            return AppState(behaviours: behaviours)
        case .increaseBehaviour(let item):
            let behaviours = behaviours.filter({ $0.id != item.id }) + [item.update(.addRawEntry)] 
            return AppState(behaviours: behaviours)
        case .decreaseBehaviour(let item):
            let behaviours = behaviours.filter({ $0.id != item.id }) + [item.update(.deleteLastRawEntry)] 
            return AppState(behaviours: behaviours)
        case .pin(let `case`):
            if case .behaviour(let item) = `case` {
                let behavious = behaviours.filter({ $0.id != item.id }) + [item.update(.pin)]
                return AppState(behaviours: behavious)
            }
            
            if case .goal(let item, let behaviour) = `case` {
                let behaviours  = behaviours.filter({ $0.id != behaviour.id }) + [behaviour.update(.pinGoal(item))]
                return AppState(behaviours: behaviours)
            }
        case .unpin(let `case`):
            if case .behaviour(let item) = `case` {
                let behaviours = behaviours.filter({ $0.id != item.id }) + [item.update(.unpin)]
                return AppState(behaviours: behaviours)
            }
            
            if case .goal(let item, let behaviour) = `case` {
                let behaviours = behaviours.filter({ $0.id != behaviour.id }) + [behaviour.update(.unpinGoal(item))]
                return AppState(behaviours: behaviours)
            }
        case .archiveBehaviour(let behaviour):
            let behaviours = behaviours.filter({ $0.id != behaviour.id }) + [behaviour.update(.archive)]
            return AppState(behaviours: behaviours)
        case .unarchiveBehaviour(let behaviour):
            let behaviours = behaviours.filter({ $0.id != behaviour.id }) + [behaviour.update(.unarchive)]
            return AppState(behaviours: behaviours)
        case .edit(let emoji, let name, let behaviour):
            let behaviours = behaviours.filter({ $0.id != behaviour.id })
            let newItem = behaviour
                .update(.emoji(emoji))
                .update(.name(name))
            
            return AppState(behaviours: behaviours + [newItem])
        case .setPresets(let presets):
            
            return AppState(behaviours: behaviours, presetsState: .success(presets))
        }
        
        return AppState()
    }
}
