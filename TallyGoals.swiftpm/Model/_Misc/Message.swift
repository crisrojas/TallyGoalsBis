import SwiftUI

enum Message {
    case presets(_Presets)
    case behaviour(_Behaviour)
    case goal(_Goal)
    
    enum _Presets {
        case read
        case response(Response)
        
        enum Response {
            case didRead
            case error
        }
    }
    
    enum _Behaviour {
        case add(BehaviourPO)
        case delete(BehaviourPO)
        case pin(BehaviourPO)
        case unpin(BehaviourPO)
        case increase(BehaviourPO)
        case decrease(BehaviourPO)
        case edit(emoji: String, title: String, of: BehaviourPO)
        case response(Response)
        case toggleArchive(BehaviourPO)
        case archive(BehaviourPO)
        case unarchive(BehaviourPO)
        
        enum Response {
            case wasAdded(BehaviourPO)
            case wasDeleted(BehaviourPO)
            case didIncrease(BehaviourPO)
            case didDecrease(BehaviourPO)
            case didPin(BehaviourPO)
            case didUnpin(BehaviourPO)
            case didArchive(BehaviourPO)
            case didUnarchive(BehaviourPO)
            case didEdit(BehaviourPO)
        }
    }
    
    enum _Goal {
        case add(GoalPO, to: BehaviourPO)
        case delete(GoalPO, of: BehaviourPO)
        case increase(GoalPO, of: BehaviourPO)
        case response(Response)
        case pin(GoalPO, of: BehaviourPO)
        case unpin(GoalPO, of: BehaviourPO)
        
        enum Response {
            case didAdd(GoalPO, to: BehaviourPO)
            case didIncrease(GoalPO, of: BehaviourPO)
            case didPin(GoalPO, of: BehaviourPO)
            case didUnpin(GoalPO, of: BehaviourPO)
            case didDelete(GoalPO, of: BehaviourPO)
        }
    }
}
