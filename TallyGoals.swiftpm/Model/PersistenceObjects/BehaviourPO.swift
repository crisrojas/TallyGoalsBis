import SwiftUI

struct BehaviourPO: Identifiable, Codable {
    let id: UUID
    let emoji: String
    let name: String
    let goals: Set<GoalPO>
    let rawEntries: Set<EntryPO>
    let isPinned: Bool
    let isArchived: Bool
}


// MARK: - Computed 
extension BehaviourPO {
    
    func completed() -> [GoalPO] { Array(goals.filter({ $0.completed() })) }
    func uncompleted() -> [GoalPO] { Array(goals.filter({ !$0.completed() })) }
    func label() -> String { emoji + " " + name }
    func goalCount() -> Int {  goals.reduce(0) { $0 + $1.entries.count } }
    func rawEntryCount() -> Int { rawEntries.count }
    func count() -> Int { goalCount() + rawEntryCount() }
}

// MARK: - Init
extension BehaviourPO {
    
    init(emoji: String, name: String) { self.init(UUID(), emoji, name, [], [], false, false) }
    
    private init(
        _ id: UUID,
        _ emoji: String,
        _ name: String,
        _ goals: Set<GoalPO>,
        _ rawEntries: Set<EntryPO>,
        _ isPinned: Bool,
        _ isArchived: Bool
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.goals = goals
        self.rawEntries = rawEntries
        self.isPinned = isPinned
        self.isArchived = isArchived
    }
}

// MARK: - Command Api
extension BehaviourPO {
    enum Update {
        case name(String)
        case emoji(String)
        case addRawEntry
        case deleteLastRawEntry
        case addGoal(GoalPO)
        case deleteGoal(GoalPO)
        case increaseGoal(GoalPO)
        case pin
        case unpin
        case archive
        case unarchive
        case pinGoal(GoalPO)
        case unpinGoal(GoalPO)
    } 
    
    func update(_ update: Update) -> BehaviourPO {
        switch update {
        case .name(let name): return .init(id, emoji, name, goals, rawEntries, isPinned, isArchived)
        case .emoji(let emoji): return .init(id, emoji, name, goals, rawEntries, isPinned, isArchived)
        case .addRawEntry:  return .init(id, emoji, name, goals, rawEntries.add(EntryPO()), isPinned, isArchived)
        case .deleteLastRawEntry: return .init(id, emoji, name, goals, rawEntries.droppingLast(), isPinned, isArchived)
        case .addGoal(let goal): return .init(id, emoji, name, goals.add(goal), rawEntries, isPinned, isArchived)
        case .pin: return .init(id, emoji, name, goals, rawEntries, true, isArchived)
        case .unpin: return .init(id, emoji, name, goals, rawEntries, false, isArchived)
        case .archive: return .init(id, emoji, name, goals, rawEntries, isPinned, true)
        case .unarchive: return .init(id, emoji, name, goals, rawEntries, isPinned, false)
        case .deleteGoal(let item): return .init(id, emoji, name, goals.delete(item), rawEntries, isPinned, isArchived)
        case .increaseGoal(let goal):
            let goals = goals
                .filter { $0.id != goal.id }
                .add(goal.update(.addEntry))
            
            return .init(id, emoji, name, goals, rawEntries, isPinned, isArchived)
        case .pinGoal(let goal):
            let goals = goals
                .filter { $0.id != goal.id }
                .add(goal.update(.pin))
            return .init(id, emoji, name, goals, rawEntries, isPinned, isArchived)
        case .unpinGoal(let goal):
            let goals = goals
                .filter { $0.id != goal.id }
                .add(goal.update(.unpin))
            return .init(id, emoji, name, goals, rawEntries, isPinned, isArchived)
        }
    }
}

extension Set {
    
    func droppingLast() -> Self { Set(self.dropLast()) }
    
    func add(_ item: Element) -> Self {
        var new = self
        new.insert(item)
        return new
    }
    
    func delete(_ item: Element) -> Self {
        var new = self
        new.remove(item)
        return new
    }
}
