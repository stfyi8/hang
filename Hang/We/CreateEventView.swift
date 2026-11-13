import SwiftUI

struct CreateEventView: View {
    @State private var eventName = ""
    @State private var eventDesc = ""
    @State private var eventLocation = ""
    @State private var eventTime = ""

    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $eventName)
                TextField("Description", text: $eventDesc)
                TextField("Location", text: $eventLocation)
                TextField("Time", text: $eventTime)
            }
            .padding()
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        // TODO: add the event to the group.
                    }
                }
            }
        }
    }
}

#Preview {
    CreateEventView()
}
