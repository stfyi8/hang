import SwiftUI

public enum GroupTab: String, CaseIterable, Identifiable {
    case cal = "Calendar"
    case events = "Events"
    case info = "More Info"

    public var id: Self { self }
}

struct GroupView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup
    @State private var selectedGroupTab: GroupTab = .events

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Picker("Picker", selection: $selectedGroupTab) {
                        ForEach(GroupTab.allCases) { gtab in
                            Text(gtab.rawValue)
                        }
                    }
                    .padding()
                    .pickerStyle(.segmented)

                    switch selectedGroupTab {
                    case .cal:
                        CalendarView(tg: $tg)
                    case .events:
                        EventView(tg: $tg)
                    case .info:
                        MoreInfoView(tg: $tg)
                    }
                }
                .navigationTitle(tg.name)
            }
        }
    }
}

#Preview {
    GroupView(
        tg: .constant(
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

struct CalendarView: View {
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

    private var members: [Person] { tg.members }

    private var availability: AvailabilityCalculator {
        AvailabilityCalculator(calendar: calendar)
    }

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

                DayAvailabilityView(
                    date: selectedDate ?? Date(),
                    members: members,
                    calendar: calendar
                )
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
        let topDays = topAvailableDays(among: days)

        return LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 2),
                count: 7
            ),
            spacing: 2
        ) {
            ForEach(days, id: \.self) { date in
                dayCell(for: date, topAvailableDays: topDays)
            }
        }
    }

    // A single day in the month grid, including its availability shading,
    // outlines, and event marker.
    private func dayCell(for date: Date, topAvailableDays: Set<Date>) -> some View {
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

        let isTopAvailable =
            topAvailableDays.contains(calendar.startOfDay(for: date))

        let freeFraction = availability.freeFraction(on: date, members: members)

        // Darker green means more of the group is free that day.
        let shading = 0.05 + 0.5 * freeFraction

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
                .background(
                    colors.green.opacity(
                        isCurrentMonth ? shading : shading * 0.4
                    ),
                    in: RoundedRectangle(cornerRadius: 8)
                )
                .overlay {
                    // Most available days of the month.
                    if isTopAvailable {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                Color.blue,
                                style: StrokeStyle(lineWidth: 1.5, dash: [3, 2])
                            )
                    }
                }
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

    // The three days of the displayed month where the group is most free.
    private func topAvailableDays(among days: [Date]) -> Set<Date> {
        let monthDays = days.filter {
            calendar.isDate($0, equalTo: displayedMonth, toGranularity: .month)
        }

        let best = monthDays
            .map { ($0, availability.freeFraction(on: $0, members: members)) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
            .prefix(3)

        return Set(best.map { calendar.startOfDay(for: $0.0) })
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

struct EventView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup
    @State private var showAddView = false
    var body: some View {
        List {
            ForEach($tg.events) { $event in
                VStack(alignment: .leading) {
                    HStack {
                        Text(event.name)
                            .font(.system(size: sizing.x4))
                        Divider()
                            .frame(width: 1)
                            .overlay(.black)
                        Text(
                            Date(timeIntervalSince1970: event.time)
                                .formatted(date: .numeric, time: .shortened)
                        )
                        .font(.system(size: sizing.x4))
                    }
                    Text(event.desc)
                        .font(.system(size: sizing.x3))
                        .lineLimit(1)
                }
                .listRowBackground(Color(.systemGray6))
            }
            Button {
                showAddView.toggle()
            } label: {
                Text("+ Add New Event")
                    .font(.system(size: sizing.x4))
                    
            } .listRowBackground(Color(.systemGray6))
        }
        .padding(.top, -sizing.x4)
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $showAddView) {
            CreateEventView(tg: $tg)
                .presentationDetents([.medium])
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

struct MoreInfoView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup

    var body: some View {
        ScrollView {
            VStack {
                Text("Invite Code")
                    .font(.system(size: sizing.x5, weight: .medium))
                    .padding(.bottom, -sizing.x1)
                ZStack {
                    RoundedRectangle(cornerRadius: sizing.x3)
                        .foregroundStyle(Color.black.opacity(0.1))
                    Text(tg.code)
                        .font(.system(size: sizing.x7, weight: .medium))
                        .padding(.vertical, sizing.x1)
                        .padding(.horizontal, sizing.x3)
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding(sizing.x1)
                Divider()
                    .frame(height: 0.8)
                    .overlay(.black)
                    .padding(.vertical, sizing.x2)
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.system(size: sizing.x6, weight: .bold))
                    Text(tg.desc)
                        .font(.system(size: sizing.x5))
                    Divider()
                        .frame(height: 0.8)
                        .overlay(.black)
                        .padding(.vertical, sizing.x2)
                    Text("Members (\(tg.members.count))")
                        .font(.system(size: sizing.x6, weight: .bold))
                    ForEach(tg.members) { member in
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: sizing.x10)
                                .fontWeight(.light)
                            VStack(alignment: .leading) {
                                Text(member.name)
                                    .font(.system(size: sizing.x5))
                                Text(member.status)
                                    .font(.system(size: sizing.x4))
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, sizing.x4)
    }
}
