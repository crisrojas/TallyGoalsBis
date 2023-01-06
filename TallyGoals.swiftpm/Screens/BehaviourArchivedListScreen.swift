import SwiftUI

struct BehaviourArchivedListScreen: View {
    let model: [BehaviourPO]
    
    let delete: (BehaviourPO) -> Void
    let toggleArchive: (BehaviourPO) -> Void
    
    var body: some View {
        List(model) { item in 
            Text(item.label())
                .swipeActions { 
                    Button(L10n.delete, role: .destructive) { delete(item) }
                    Button(L10n.unarchive) { toggleArchive(item) }
                }
        }
    }
}
