import SwiftUI

struct BehaviourDetailScreen: View {
    
    let behaviour: BehaviourPO
    let increase: (BehaviourPO) -> Void
    let decrease: (BehaviourPO) -> Void
    let increaseGoal: (GoalPO, BehaviourPO) -> Void
    
    var increaseDisabled: Bool { behaviour.rawEntryCount() == 0 }
    let onDelete: (GoalPO, BehaviourPO) -> Void
    let onCreate: (GoalPO, BehaviourPO) -> Void
    let edit: (String, String, BehaviourPO) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 24) {
                
                Button("-") { decrease(behaviour) }
                    .disabled(increaseDisabled)
                
                Text(behaviour.count().description)
                    .fontWeight(.black)
                
                Button("+") { increase(behaviour) }
            }
            .font(.title)
            .padding(.top, 32)
            
            if behaviour.goals.isEmpty {
                Text(L10n.noGoalsAddedYet)
                NavigationLink(L10n.createGoal) { BehaviourDetailCreateScreen(model: behaviour, onCreate: onCreate)}
            } else {
                List { 
                    list(heading: L10n.uncompleted, model: behaviour.uncompleted())
                    list(heading: L10n.completed, model: behaviour.completed())
                }
            }
        }
        .navigationTitle(behaviour.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { 
            HStack {
                NavigationLink { BehaviourDetailCreateScreen(model: behaviour, onCreate: onCreate) } label: { Image(systemName: "plus") }
                NavigationLink { BehaviourEditScreen(behaviour: behaviour, saveAction: edit) } label: { Image(systemName: "pencil") }
            }
        }
    }
    
    func list(heading: String, model: [GoalPO], allowIncrease: Bool = false) -> some View {
        if !model.isEmpty {
            return Section(heading) { 
                ForEach(model) { goal in
                    Text(goal.progressLabel())
                        .onTapGesture { if allowIncrease { increaseGoal(goal, behaviour)} }
                }
                .onDelete { 
                    let goal = model[$0.first!]
                    onDelete(goal, behaviour)
                }
            }
        } else { return EmptyView() }
    }
}

struct BehaviourDetailCreateScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var text = ""
    let model: BehaviourPO
    let onCreate: (GoalPO, BehaviourPO) -> Void
    var isDisabled: Bool { Int(text) == nil }
    
    var body: some View {
        Form {
            TextField(L10n.goalValue, text: $text)
            Button(L10n.create) {
                let goal = GoalPO(value: Int(text)!)
                onCreate(goal, model)
                dismiss()
            }
            .disabled(isDisabled)
        }
    }
}

extension Set {
    func toArray() -> [Element] { Array(self) }
}
