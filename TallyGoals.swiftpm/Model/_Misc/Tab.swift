import SwiftUI

enum Tab {
    case goals
    case behaviours
    case completed
    case inspiration
    
    var title: String {
        switch self {
        case .behaviours: return L10n.behaviours
        case .goals: return L10n.goals
        case .completed: return L10n.completed
        case .inspiration: return L10n.inspiration
        }
    }
    
    var systemImage: String {
        switch self {
        case .behaviours: return "list.dash"
        case .goals: return "flag"
        case .completed: return "checkmark"
        case .inspiration: return "star"
        }
    }
}
