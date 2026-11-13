import Foundation
import SwiftUI

public struct Colors {
    let green = Color(red: 0.4, green: 0.7, blue: 0.6)
    let green1 = Color(red: 0.6, green: 0.9, blue: 0.8)
    let green2 = Color(red: 0.7, green: 1, blue: 0.9)
    let dgreen = Color(red: 0.2, green: 0.5, blue: 0.4)
    let dgreen1 = Color(red: 0.1, green: 0.4, blue: 0.3)
    let dgreen2 = Color(red: 0, green: 0.3, blue: 0.2)
    let brown = Color.brown
    let txt1 = Color(red: 0.1, green: 0.25, blue: 0.2)
    let txt2 = Color(red: 0.05, green: 0.2, blue: 0.15)
    let obj = Color(red: 0.25, green: 0.15, blue: 0)
}

struct Sizing: DynamicProperty {
    @ScaledMetric var x1: CGFloat = 5
    @ScaledMetric var x2: CGFloat = 10
    @ScaledMetric var x3: CGFloat = 15
    @ScaledMetric var x4: CGFloat = 20
    @ScaledMetric var x5: CGFloat = 25
    @ScaledMetric var x6: CGFloat = 30
    @ScaledMetric var x7: CGFloat = 35
    @ScaledMetric var x8: CGFloat = 40
    @ScaledMetric var x9: CGFloat = 45
    @ScaledMetric var x10: CGFloat = 50
}


public struct TestGroup: Hashable, Identifiable {
    public let id = UUID()
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

public enum clickStyle {
    case None, Tint, Fade, Shrink1, Shrink2
}

public struct setStyle : ButtonStyle {
    public let styleName: clickStyle
    public func makeBody(configuration: Configuration) -> some View {
        switch styleName {
        case .None:
            configuration.label
        case .Tint:
            configuration.label
                .overlay{
                    Color.black
                        .opacity(configuration.isPressed ? 0.2 : 0)
                }
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        case .Fade:
            configuration.label
                .opacity(configuration.isPressed ? 0.75 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        case .Shrink1:
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        case .Shrink2:
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        }
    }
}
