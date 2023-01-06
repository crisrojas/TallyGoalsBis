import SwiftUI

struct GoalAddScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var value = ""
    @State var selectedBehaviour: BehaviourPO?
    
    let behaviours: [BehaviourPO]
    let createBehaviour: (String, String) -> Void
    let createAction: (GoalPO, BehaviourPO) -> Void
    var createDisabled: Bool { Int(value) == nil || selectedBehaviour == nil }
    
    var body: some View {
        Form {
            behaviourRow
            TextField(L10n.goalValue, text: $value)
        }
        .toolbar { 
            Button(L10n.create) {
                guard
                    let value = Int(value),
                    let behaviour = selectedBehaviour
                else { return  }
                
                createAction(GoalPO(value: value), behaviour)
                dismiss()
            }
            .disabled(createDisabled)
        }
    }
    
    var behaviourRow: some View {
        NavigationLink { 
            BehaviourSelection(
                selectedBehaviour: $selectedBehaviour, 
                behaviours: behaviours,
                createAction: createBehaviour
            )
        } label: { 
            Text(selectedBehaviour?.label() ?? L10n.selectBehaviour)
        }
    }
}
