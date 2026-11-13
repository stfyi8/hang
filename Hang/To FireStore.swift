import Foundation
import SwiftUI

public struct TestGroup: Hashable, Identifiable {
    public let id = UUID()
    public let code: String
    var name: String
    var desc: String = "Add description here..."
    var members : Array<Person> = [
        Person(name: "Tiffany", status: "hello"),
        Person(name: "Serene", status: "hi"),
        Person(name: "Iain", status: "hey"),
        Person(name: "Zixi", status: "wassup")
    ]
    var events : Array<GroupEvents> = []
}

public struct GroupEvents: Hashable, Identifiable {
    public let id = UUID()
    var name: String
    var desc: String = "Add description here..."
    var time: Double
}
public struct Person: Hashable, Identifiable {
    public let id = UUID()
    var name: String
    var status: String = "Add description here..."
}
