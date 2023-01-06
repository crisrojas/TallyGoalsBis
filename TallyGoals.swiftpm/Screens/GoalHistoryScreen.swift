import SwiftUI

struct GoalHistoryScreen: View {
    
    let model: [GoalVO]
    let onDelete: (GoalPO, BehaviourPO) -> Void
    
    var body: some View {
        if model.isEmpty {
            Text(L10n.noGoalsCompletedYet).frame(width: 200).multilineTextAlignment(.center)
        } else {
            List { 
                ForEach(model) { item in 
                    HStack {
                        if let date = item.goal.lastEntryDate() { Text(date).font(.caption2) }
                        Text(item.label)
                    }
                }
                .onDelete {
                    let item = model[$0.first!]
                    onDelete(item.goal, item.behaviour)
                }
            }
        }
    }
}
