import SwiftUI

struct ContentView: View {
    var sizing = Sizing()
    var body: some View {
        VStack {
            TabView() {
                Tab("We", systemImage: "person.and.person.fill") {
                        WeView()
                }
                Tab("Me", systemImage: "smiley") {
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
