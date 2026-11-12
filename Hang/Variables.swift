import Foundation
import SwiftUI

public func colNormal(r: Int, g: Int, b: Int) -> Color{
    let r1 = Double(r)/255.0
    let g1 = Double(g)/255.0
    let b1 = Double(b)/255.0
    return Color(red: r1, green: g1, blue: b1)
}
public func colAlpha(r: Int, g: Int, b: Int, a: Double) -> Color{
    let r1 = Double(r)/255.0
    let g1 = Double(g)/255.0
    let b1 = Double(b)/255.0
    return Color(red: r1, green: g1, blue: b1).opacity(a)
}

public var Colors : Array<Color> = [
    Color(red: 1, green: 1, blue: 1)
]

struct Spacing: DynamicProperty {
    @ScaledMetric var x1: CGFloat = 5
    @ScaledMetric var x2: CGFloat = 10
    @ScaledMetric var x3: CGFloat = 15
    @ScaledMetric var x4: CGFloat = 20
    @ScaledMetric var x5: CGFloat = 25
    @ScaledMetric var x6: CGFloat = 30
}

struct TextSize: DynamicProperty {
    @ScaledMetric var x2: CGFloat = 10
    @ScaledMetric var x3: CGFloat = 15
    @ScaledMetric var x4: CGFloat = 20
    @ScaledMetric var x5: CGFloat = 25
    @ScaledMetric var x6: CGFloat = 30
    @ScaledMetric var x7: CGFloat = 35
}

public struct TestGroups: Hashable, Identifiable {
    public let id = UUID()
    var name: String
    var peopleCount: Int
}

public enum clickStyle {
    case None, Tint, Fade, Shrink
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
        case .Shrink:
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
        }
    }
}
