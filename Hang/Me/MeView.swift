import SwiftUI

struct MeView: View {

    @FocusState var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("MEEEEEEE!!!!!!")
            }
            .navigationTitle("My Calendar")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Label("Profile", systemImage: "person.fill")
                    }

                }
            }

        }
    }
}

#Preview {
    MeView()
}
