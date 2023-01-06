import SwiftUI


struct GoalPO: Identifiable, Hashable, Codable {
    let id: UUID
    let value: Int
    let entries: Set<EntryPO>
    let isPinned: Bool
    let isArchived: Bool
}

// MARK: - Computed
extension GoalPO {
    func completed() -> Bool { entries.count >= value }
    func progressLabel() -> String { entries.count.description + "/" + value.description }
    func lastEntryDate() -> String? { entries.sorted(by: { $0.creationDate < $1.creationDate }).last?.creationDate.yyyyMMdd }
}

// MARK: - Init
extension GoalPO {
    init(value: Int) {
        self.init(UUID(), value, [], false, false)
    }
    
    private init(_ id: UUID, _ value: Int, _ entries: Set<EntryPO>, _ isPinned: Bool, _ isArchived: Bool) {
        self.id = id
        self.value = value
        self.entries = entries
        self.isPinned = isPinned
        self.isArchived = isArchived
    }
}

// MARK: - Command Api
extension GoalPO {
    
    enum Update {
        case addEntry
        case pin
        case unpin
        case archive
        case unarchive
    }
    
    func update(_ update: Update) -> GoalPO {
        switch update {
            case .addEntry: return .init(id, value, entries.add(EntryPO()), isPinned, isArchived) 
            case .pin: return .init(id, value, entries, true, isArchived)
            case .unpin: return .init(id, value, entries, false, isArchived)
            case .archive: return .init(id, value, entries, isPinned, true)
            case .unarchive: return .init(id, value, entries, isPinned, false)
        }
    }
}
