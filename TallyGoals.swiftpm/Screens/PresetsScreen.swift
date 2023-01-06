import SwiftUI

struct PresetsScreen: View {
    
    #warning("move preset state enum here")
    let state: AppState.PresetsState
    let loadAction: () -> Void
    let addAction: (String, String) -> Void
    
    var body: some View {
        switch state {
            case .idle, .loading: ProgressView().onAppear(perform: loadAction)
            case .success(let categories): list(categories: categories)
            case .error: Button(L10n.errorTapToReload) { loadAction() }
        }
    }
    
    func list(categories: [PresetCategory]) -> some View {
        List { 
            ForEach(categories) { category in
                NavigationLink { 
                    list(emoji: category.emoji, presets: category.presets) 
                } label: {  Text(category.label()) }
            } 
        }
    }
    
    func list(emoji: String, presets: [Preset]) -> some View { 
        List(presets) { item in
            HStack(alignment: .top) {
                Text(emoji)
                Text(item.title).minimumScaleFactor(0.7).lineLimit(2)
                Spacer()
                Button(L10n.add) { addAction(emoji, item.title) }
            }
        } 
    }
}

