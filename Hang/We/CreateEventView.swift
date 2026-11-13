import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var events: [GroupEvents]

    @State private var eventName = ""
    @State private var eventDesc = ""
    @State private var eventLocation = ""
    @State private var eventDate: Date

    init(events: Binding<[GroupEvents]>, initialDate: Date = Date()) {
        _events = events
        _eventDate = State(initialValue: initialDate)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Details") {
                    TextField("Name", text: $eventName)
                    TextField("Description", text: $eventDesc, axis: .vertical)
                    TextField("Location", text: $eventLocation)
                }

                Section("Date and Time") {
                    DatePicker(
                        "Date",
                        selection: $eventDate,
                        displayedComponents: .date
                    )
                    HStack(spacing: 6) {
                        Text("Time")
                        Spacer()
                        DatePicker(
                            "",
                            selection: $eventDate,
                            displayedComponents: .hourAndMinute
                        )
                        Text("to")
                        DatePicker(
                            "",
                            selection: $eventDate,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
            }
            .navigationTitle("New Event")
            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        events.append(
                            GroupEvents(
                                name: eventName.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                desc: eventDesc.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                time: eventDate.timeIntervalSince1970
                            )
                        )
                        dismiss()
                    }
                    .disabled(
                        eventName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
        }
    }
}

#Preview {
    CreateEventView(events: .constant([]))
}
