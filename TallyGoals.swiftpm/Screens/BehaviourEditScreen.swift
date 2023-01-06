import SwiftUI

struct BehaviourEditScreen: View {
    
    @State var emoji = ""
    @State var title = ""
    
    let behaviour: BehaviourPO
    let saveAction: (String, String, BehaviourPO) -> Void
    var buttonDisabled: Bool { emoji.isEmpty || title.isEmpty }
    
    var body: some View {
        Form {
            TextField(behaviour.emoji, text: $emoji)
            TextField(behaviour.name, text: $title)
        }
        .toolbar {
            Button(L10n.save) { saveAction(emoji, title, behaviour) }
                .disabled(buttonDisabled)
        }
    }
}
