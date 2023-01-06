import SwiftUI

struct EntryPO: Identifiable, Hashable, Codable {
    let id: UUID
    let creationDate: Date
}

extension EntryPO {
    init(_ id: UUID = UUID(), creationDate: Date = Date()) { 
        self.id = id
        self.creationDate = creationDate
    }
}
