import SwiftUI

struct GoalListScreen: View {
    
    let goals: [GoalVO]
    let increase: (GoalPO, BehaviourPO) -> Void
    let delete: (GoalPO, BehaviourPO) -> Void
    let pinning: (Bool, GoalPO, BehaviourPO) -> Void
    
    var body: some View {
        if goals.isEmpty {
            Text(L10n.noGoalsAddedYet)
        } else {
            List(goals) { goal in
                row(item: goal)
                    .swipeActions { swipeActions(goal.goal, goal.behaviour) }
                    .onTapGesture { increase(goal.goal, goal.behaviour) }
            }
        }
    }
    
    @ViewBuilder
    func swipeActions(_ goal: GoalPO, _ behaviour: BehaviourPO) -> some View {
        deleteButton(goal: goal, behaviour: behaviour)
        pinButton(goal: goal, behaviour: behaviour)
    }
    
    func row(item: GoalVO) -> some View {
        HStack {
            if item.goal.isPinned { Image(systemName: "pin.fill").resizable().frame(width: 6).frame(height: 10) }
            Text(item.label)
        }
    }
    
    func pinButton(goal: GoalPO, behaviour: BehaviourPO) -> some View { 
        Button(goal.isPinned ? L10n.unpin : L10n.pin) { pinning(!goal.isPinned, goal, behaviour)}
    }
    
    func deleteButton(goal: GoalPO, behaviour: BehaviourPO) -> some View {
        Button(L10n.delete, role: .destructive) { delete(goal, behaviour) }
    }
}
