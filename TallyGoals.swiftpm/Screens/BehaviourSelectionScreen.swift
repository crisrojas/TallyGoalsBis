import SwiftUI

struct BehaviourSelection: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedBehaviour: BehaviourPO?
    let behaviours: [BehaviourPO]
    let createAction: (String, String) -> Void
    
    var body: some View {
        if behaviours.isEmpty {
            VStack(spacing: 24) {
                Text(L10n.noBehavioursAddedYet)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
                NavigationLink { BehaviourAddScreen(saveAction: createAction) } label: { Text(L10n.create) }
            }
        } else {
            List(behaviours) { item in
                Text(item.label())
                    .onTapGesture {
                        selectedBehaviour = item
                        dismiss()
                    }
            }
        }
    }
}
