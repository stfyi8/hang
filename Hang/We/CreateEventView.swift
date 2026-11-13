import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var eventName = ""
    @State private var eventDesc = ""
    @State private var eventTime = ""
    @Binding var tg: TestGroup
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $eventName)
                    .listRowBackground(Color(.systemGray6))
                TextField("Description", text: $eventDesc)
                    .listRowBackground(Color(.systemGray6))
                TextField("Time", text: $eventTime).listRowBackground(Color(.systemGray6))
            }
            .padding()
            .scrollContentBackground(.hidden)
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        tg.events.append(GroupEvents(name: eventName, desc: eventDesc, time: Date().timeIntervalSince1970))
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateEventView(tg: .constant(
        TestGroup(
            code: "HELLO1", name: "CODZEE",
            events: [
                GroupEvents(name: "event1", time: 1_720_708_600),
                GroupEvents(name: "event2", time: 1_790_403_500),
            ]
        )
    ))
}
