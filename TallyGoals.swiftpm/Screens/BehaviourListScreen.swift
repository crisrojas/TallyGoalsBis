import SwiftUI

struct BehaviourListScreen: View {
    let list: [BehaviourPO]
    let increase: (BehaviourPO) -> Void
    let decrease: (BehaviourPO) -> Void
    let pinning: (Bool, BehaviourPO) -> Void
    let togglArchive: (BehaviourPO) -> Void
    let increaseGoal: (GoalPO, BehaviourPO) -> Void
    let onDelete: (BehaviourPO) -> Void
    let onCreateGoal: (GoalPO, BehaviourPO) -> Void
    let onDeleteGoal: (GoalPO, BehaviourPO) -> Void
    let edit: (String, String, BehaviourPO) -> Void
    
    var body: some View {
        if list.isEmpty {
            Text(L10n.noBehavioursAddedYet)
                .multilineTextAlignment(.center)
                .frame(width: 200)
        } else {
            List {
                ForEach(list) { item in
                    NavigationLink(destination: { detailScreen(model: item) }, label: { row(item: item) })
                    .swipeActions(allowsFullSwipe: true) { 
                        Button(L10n.delete, role: .destructive) { onDelete(item) }
                        Button(L10n.archive) { togglArchive(item) }
                        pinButton(item: item)
                    }
                }
            }
        }
    }
    
    func pinButton(item: BehaviourPO) -> some View {
        Button(item.isPinned ? L10n.unpin: L10n.pin) { pinning(!item.isPinned, item) }
    }
    
    func row(item: BehaviourPO) -> some View {
        HStack {
            if item.isPinned { Image(systemName: "pin.fill").resizable().frame(width: 6).frame(height: 10) }
            Text(item.label())
        }
    }
    
    func detailScreen(model: BehaviourPO) -> some View {
        BehaviourDetailScreen(
            behaviour: model,
            increase: increase,
            decrease: decrease,
            increaseGoal: increaseGoal,
            onDelete: onDeleteGoal,
            onCreate: onCreateGoal,
            edit: edit
        )
    }
}


