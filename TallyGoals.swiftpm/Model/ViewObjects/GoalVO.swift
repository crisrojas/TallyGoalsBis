import Foundation

#warning("@todo: Don't pass full goal boject but only needed values")
struct GoalVO: Identifiable {
    let id: UUID
    let behaviour: BehaviourPO
    let goal: GoalPO
    let value: Int
    let progress: Int
    
    var completed: Bool { progress >= value }
    var behaviourLabel: String { behaviour.label() }
    var label: String { progressLabel + " " + behaviourLabel }
    var progressLabel: String { progress.description + "/" + value.description }
}
