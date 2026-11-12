import SwiftUI

struct ContentView: View {
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
        .padding()
    }
}

#Preview {
    ContentView()
}
