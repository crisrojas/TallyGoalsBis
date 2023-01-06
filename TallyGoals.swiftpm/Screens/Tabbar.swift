import SwiftUI

struct Tabbar: View {
    
    @StateObject var viewState: ViewState
    let rootHandler: AppCore
    
    var body: some View {
        TabView(selection: $viewState.selectedTab) {
            tab(.goals, content: goalList)
            tab(.behaviours, content: behaviourList)
            tab(.completed, content: goalHistoryList)
            tab(.inspiration, content: presetsScreen)
        }
    }
    
    func tab<Content: View>(_ tab: Tab, content: Content) -> some View {
        NavigationView { content.navigationTitle(tab.title) }
            .tabItem { Label(tab.title, systemImage: tab.systemImage) }
            .tag(tab)
    }
}

// MARK: - App actions
#warning("@todo: Pass item ids instead of full objects")
extension Tabbar {
    
    func edit(emoji: String, title: String, of behaviour: BehaviourPO) { 
        rootHandler(.behaviour(.edit(emoji: emoji, title: title, of: behaviour)))
    }
    func togglArchive(item: BehaviourPO) { rootHandler(.behaviour(.toggleArchive(item))) }
    func onDelete(item: BehaviourPO) { rootHandler(.behaviour(.delete(item)))   }
    func increase(item: BehaviourPO) { rootHandler(.behaviour(.increase(item))) }
    func decrease(item: BehaviourPO) { rootHandler(.behaviour(.decrease(item))) }
    
    #warning("abstract to togglpin message")
    func pinning(pin: Bool, item: BehaviourPO) { 
        if pin { rootHandler(.behaviour(.pin(item))); return }
        rootHandler(.behaviour(.unpin(item)))
    }
    
    func pinning(pin: Bool, item: GoalPO, of behaviour: BehaviourPO) { 
        if pin { rootHandler(.goal(.pin(item, of: behaviour))) ; return }
        rootHandler(.goal(.unpin(item, of: behaviour)))
    }
    
    func   delete(goal: GoalPO,  of behaviour: BehaviourPO) { rootHandler(.goal(.delete(goal, of: behaviour)))   }
    func increase(goal: GoalPO,  of behaviour: BehaviourPO) { rootHandler(.goal(.increase(goal, of: behaviour))) }
    func   create(goal: GoalPO, for behaviour: BehaviourPO) { rootHandler(.goal(.add(goal, to: behaviour)))      }
    
    func addAction(_ emoji: String, _ name: String) { rootHandler(.behaviour(.add(BehaviourPO(emoji: emoji, name: name)))) }
}

// MARK: - App Screens
extension Tabbar {
    var presetsScreen: some View {
        PresetsScreen(
            state: viewState.presetState,
            loadAction: { rootHandler(.presets(.read)) },
            addAction: addAction(_:_:)
        )
    }
    
    var goalHistoryList: some View { 
        GoalHistoryScreen(
            model: viewState.completedGoals,
            onDelete: delete(goal:of:)
        )
    }
    
    var goalList: some View {
        GoalListScreen(
            goals: viewState.uncompletedGoals,
            increase: increase(goal:of:),
            delete: delete(goal:of:),
            pinning: pinning(pin:item:of:)
        )
        .toolbar { NavigationLink { goalAddScreen } label: { Image(systemName: "plus") } }
    }
    
    var behaviourList: some View {
        BehaviourListScreen(
            list: viewState.unarchivedBehavious, 
            increase: increase(item:),
            decrease: decrease(item:), 
            pinning: pinning(pin:item:),
            togglArchive: togglArchive(item:),
            increaseGoal: increase(goal:of:),
            onDelete: onDelete(item:),
            onCreateGoal: create(goal:for:),
            onDeleteGoal: delete(goal:of:),
            edit: edit(emoji:title:of:)
        )
        .toolbar { 
            HStack {
                NavigationLink { BehaviourAddScreen(saveAction: addAction(_:_:)) } label: { Image(systemName: "plus") } 
                if viewState.archivedBehaviours.isNotEmpty { 
                    NavigationLink { archivedBehaviours } label: { Image(systemName: "archivebox") }
                }
            }
        }
    }
    
    var archivedBehaviours: some View {
        BehaviourArchivedListScreen(
            model: viewState.archivedBehaviours, 
            delete: onDelete(item:), 
            toggleArchive: togglArchive(item:))
    }
    
    var goalAddScreen: some View {
        GoalAddScreen(
            behaviours: viewState.behaviours, 
            createBehaviour: addAction(_:_:),
            createAction: create(goal:for:)
        )
    }
}


extension Array { var isNotEmpty: Bool { !isEmpty } }
extension Date { var yyyyMMdd: String { DateFormatter.yyyyMMdd.string(from: self) } }
extension DateFormatter {
    static var yyyyMMdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }
}
