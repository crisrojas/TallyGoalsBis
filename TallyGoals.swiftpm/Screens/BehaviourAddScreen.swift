import SwiftUI

struct BehaviourAddScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var emoji: String = ""
    @State private var name: String = "" 
    
    var saveDisabled: Bool { name.isEmpty || emoji.isEmpty }
    let saveAction: (String, String) -> Void
    
    var body: some View {
        Form {
            TextField(L10n.emoji, text: $emoji)
            TextField(L10n.name, text: $name)
        }
        .toolbar { 
            Button(L10n.create) {
                saveAction(emoji, name)
                dismiss()
            }
            .disabled(saveDisabled)
        }
    }
    
    func validationError(_ label: String) -> Text {
        Text(label)
            .font(.caption2)
            .foregroundColor(.red)
    }
}
