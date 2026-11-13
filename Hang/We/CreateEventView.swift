import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var tg: TestGroup

    @State private var eventName = ""
    @State private var eventDesc = ""
    @State private var eventLocation = ""
    @State private var eventDate: Date

    init(tg: Binding<TestGroup>, initialDate: Date = Date()) {
        _tg = tg
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
                        tg.events.append(
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
    CreateEventView(
        tg: .constant(
            TestGroup(
                code: "HELLO1",
                name: "CODZEE",
                events: [
                    GroupEvents(name: "event1", time: 1_720_708_600),
                    GroupEvents(name: "event2", time: 1_790_403_500),
                ]
            )
        )
    )
}
