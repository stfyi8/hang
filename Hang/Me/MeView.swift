import SwiftUI

struct MeView: View {
    @FocusState var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                PersonalCalendarView( tg: .constant(
                    TestGroup(
                        code: "HELLO1", name: "CODZEE",
                        events: [
                            GroupEvents(name: "event1", time: 1_720_708_600),
                            GroupEvents(name: "event2", time: 1_790_403_500),
                        ]
                    )
                )
)
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

struct PersonalCalendarView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup

    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()

    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = Date()
    @State private var isShowingCreateEvent = false


    // MARK: - Month grid

    private func generateMonthGrid() -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(
                of: .month,
                for: displayedMonth
            ),
            let firstWeek = calendar.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.start
            ),
            let lastWeek = calendar.dateInterval(
                of: .weekOfMonth,
                for: monthInterval.end.addingTimeInterval(-1)
            )
        else {
            return []
        }

        var dates: [Date] = []
        var currentDate = firstWeek.start

        while currentDate < lastWeek.end {
            dates.append(currentDate)

            guard
                let nextDate = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: currentDate
                )
            else {
                break
            }

            currentDate = nextDate
        }

        return dates
    }

    private var weekdays: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        return Array(symbols[1...6] + [symbols[0]])
    }

    private var todayWeekdayIndex: Int {
        let originalIndex = calendar.component(.weekday, from: Date()) - 1
        return (originalIndex + 6) % 7
    }

    private func changeMonth(by value: Int) {
        displayedMonth =
            calendar.date(byAdding: .month, value: value, to: displayedMonth)
            ?? displayedMonth
    }

    private func weekdayCell(at index: Int) -> some View {
        let isToday = index == todayWeekdayIndex

        let textColor: Color = isToday ? .primary : .gray

        let backgroundColor: Color =
            isToday
            ? .secondary.opacity(0.4)
            : .secondary.opacity(0.2)

        return Text(weekdays[index])
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .foregroundStyle(textColor)
            .padding(.vertical, 3)
            .background(
                backgroundColor,
                in: RoundedRectangle(cornerRadius: 8)
            )
    }

    var body: some View {
        // The whole calendar scrolls as one page, so the availability timeline
        // below the month grid stays fully visible without its own scroller.
        ScrollView {
            VStack(spacing: 2) {
                monthHeader
                monthGrid

                Divider()
                    .padding(.vertical, 8)

               
            }
            .padding(15)
        }
        .overlay(alignment: .bottomTrailing) {
            createEventButton
        }
        .sheet(isPresented: $isShowingCreateEvent) {
            CreateEventView(
                tg: $tg,
                initialDate: selectedDate ?? Date()
            )
        }
    }

    private var monthHeader: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.headline)
                Spacer()
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .tint(.primary)
            .padding(.horizontal)

            HStack(spacing: 2) {
                ForEach(weekdays.indices, id: \.self) { index in
                    weekdayCell(at: index)
                }
            }
        }
    }

    private var monthGrid: some View {
        let days = generateMonthGrid()
        

        return LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 2),
                count: 7
            ),
            spacing: 2
        ) {
            ForEach(days, id: \.self) { date in
                dayCell(for: date)
            }
        }
    }

    // A single day in the month grid, including its availability shading,
    // outlines, and event marker.
    private func dayCell(for date: Date) -> some View {
        let isCurrentMonth = calendar.isDate(
            date,
            equalTo: displayedMonth,
            toGranularity: .month
        )

        let isSelected =
            selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false

        let hasEvents = tg.events.contains {
            calendar.isDate(
                Date(timeIntervalSince1970: $0.time),
                inSameDayAs: date
            )
        }

       


        return Button {
            selectedDate = date
        } label: {
            Text("\(calendar.component(.day, from: date))")
                .font(.subheadline)
                .frame(maxWidth: .infinity, minHeight: 45)
                .overlay(alignment: .bottom) {
                    if hasEvents {
                        Image(systemName: "calendar")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.bottom, 4)
                    }
                }
                .foregroundStyle(isCurrentMonth ? .primary : .secondary)
             
                
                .overlay {
                    // Days that already have an event.
                    if hasEvents {
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.orange, lineWidth: 2)
                            .padding(2)
                    }
                }
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(colors.dgreen, lineWidth: 2.5)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    // Floating action button, pinned to the bottom of the screen so it stays
    // reachable while the calendar page is scrolled.
    private var createEventButton: some View {
        Button {
            isShowingCreateEvent = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(colors.dgreen, in: Circle())
                .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
        }
        .padding(20)
        .accessibilityLabel("New event")
    }
}
