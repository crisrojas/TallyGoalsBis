import SwiftUI

struct Preset: Identifiable, Hashable, Codable {
    let id = UUID()
    let title: String
}

struct PresetsResponse: Codable { let categories: [PresetCategory] }

struct PresetCategory: Identifiable, Codable {
    var id: String { emoji + title }
    let emoji: String
    let title: String
    let presets: [Preset]
    
    func label() -> String { emoji + " " + title }
}
