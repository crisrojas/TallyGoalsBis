import SwiftUI

protocol UseCase {
    associatedtype RequestType
    associatedtype ResponseType
    
    func request(_ request: RequestType)
}

typealias Feature = Input
typealias Input = (Message) -> Void
typealias Output = (Message) -> Void
