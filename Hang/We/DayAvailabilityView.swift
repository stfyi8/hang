//
//  DayAvailabilityView.swift
//  Hang
//
//  Shows each group member's free and busy blocks for a single day.
//
//  Layout: time runs down the page on the leading edge, and every member gets
//  their own column with their avatar on top. The view lays out at its full
//  height and leaves scrolling to the enclosing CalendarView, so the whole
//  calendar scrolls as one page. Pinching changes the height of each hour row.
//

import SwiftUI

struct DayAvailabilityView: View {
    var colors = Colors()
    let date: Date
    let members: [Person]
    let calendar: Calendar

    /// Committed pinch-to-zoom level for the hour rows.
    @State private var zoom: CGFloat = 1

    /// Live pinch delta. `@GestureState` resets it to 1 when the gesture ends.
    @GestureState private var pinch: CGFloat = 1

    private let gutterWidth: CGFloat = 44
    private let avatarRowHeight: CGFloat = 50
    private let baseHourHeight: CGFloat = 54

    private var calculator: AvailabilityCalculator {
        AvailabilityCalculator(calendar: calendar)
    }

    private var window: DateInterval {
        calculator.window(for: date)
    }

    /// Every whole hour in the availability window, e.g. 8 through 21.
    private var hours: [Int] {
        Array(AvailabilityDay.startHour..<AvailabilityDay.endHour)
    }

    // MARK: - Zoom

    private var effectiveZoom: CGFloat {
        min(max(zoom * pinch, 0.7), 2.2)
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0.01)
            .updating($pinch) { value, state, _ in
                state = value.magnification
            }
            .onEnded { value in
                zoom = min(max(zoom * value.magnification, 0.7), 2.2)
            }
    }

    // MARK: - Metrics

    private var hourHeight: CGFloat {
        baseHourHeight * effectiveZoom
    }

    /// Height of one member column, covering the whole availability window.
    private var gridHeight: CGFloat {
        CGFloat(hours.count) * hourHeight
    }

    private var totalHeight: CGFloat {
        avatarRowHeight + gridHeight
    }

    // MARK: - Formatting

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        return formatter
    }()

    private static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ha")
        return formatter
    }()

    private func hourLabel(for hour: Int) -> String {
        let offset = hour - AvailabilityDay.startHour
        let hourDate =
            calendar.date(byAdding: .hour, value: offset, to: window.start)
            ?? window.start
        return Self.hourFormatter.string(from: hourDate)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerRow
            timeline
        }
    }

    private var headerRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Availability")
                .font(.subheadline.bold())
            Text(Self.dateFormatter.string(from: date))
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    /// Hour labels on the leading edge, member columns filling the rest of the width.
    private var timeline: some View {
        GeometryReader { proxy in
            let contentWidth = max(proxy.size.width - gutterWidth, 1)
            let columnWidth = contentWidth / CGFloat(max(members.count, 1))

            HStack(alignment: .top, spacing: 0) {
                hourGutter

                VStack(spacing: 0) {
                    avatarRow(columnWidth: columnWidth, contentWidth: contentWidth)
                    grid(columnWidth: columnWidth, contentWidth: contentWidth)
                }
            }
        }
        .frame(height: totalHeight)
        .simultaneousGesture(magnificationGesture)
        .background(
            Color.primary.opacity(0.03),
            in: RoundedRectangle(cornerRadius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }

    private var hourGutter: some View {
        VStack(spacing: 0) {
            // Aligns the first hour label with the top of the member columns.
            Color.clear
                .frame(width: gutterWidth, height: avatarRowHeight)

            ForEach(hours, id: \.self) { hour in
                Text(hourLabel(for: hour))
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .frame(
                        width: gutterWidth - 6,
                        height: hourHeight,
                        alignment: .topTrailing
                    )
                    .padding(.trailing, 6)
                    .offset(y: -5)
            }
        }
        .frame(width: gutterWidth)
        .allowsHitTesting(false)
    }

    private func avatarRow(columnWidth: CGFloat, contentWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(members) { member in
                VStack(spacing: 3) {
                    Text(String(member.name.prefix(1)))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(member.tint, in: Circle())

                    Text(member.name)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .frame(width: columnWidth, height: avatarRowHeight)
            }
        }
        .frame(width: contentWidth, height: avatarRowHeight, alignment: .leading)
        .accessibilityHidden(true)
    }

    /// Member columns with hour gridlines drawn over the top.
    private func grid(columnWidth: CGFloat, contentWidth: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 0) {
                ForEach(members) { member in
                    memberColumn(member, columnWidth: columnWidth)
                }
            }

            hourLines(contentWidth: contentWidth)
        }
        .frame(width: contentWidth, height: gridHeight, alignment: .topLeading)
    }

    private func memberColumn(_ member: Person, columnWidth: CGFloat) -> some View {
        let busy = calculator.busyIntervals(for: member, on: date)

        return ZStack(alignment: .topLeading) {
            // The whole window is free until a busy block says otherwise.
            colors.green.opacity(0.12)

            ForEach(Array(busy.enumerated()), id: \.offset) { _, interval in
                busyBlock(interval, tint: member.tint, columnWidth: columnWidth)
            }
        }
        .frame(width: columnWidth, height: gridHeight)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(Color.primary.opacity(0.06))
                .frame(width: 1)
        }
    }

    private func busyBlock(
        _ interval: DateInterval,
        tint: Color,
        columnWidth: CGFloat
    ) -> some View {
        let startHours = interval.start.timeIntervalSince(window.start) / 3600
        let durationHours = interval.duration / 3600

        let barWidth = max(columnWidth - 10, 6)
        let barHeight = max(4, CGFloat(durationHours) * hourHeight - 1)
        let cornerRadius = min(8, barWidth / 3)

        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(tint.opacity(0.75))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(tint, lineWidth: 1)
            )
            .frame(width: barWidth, height: barHeight)
            .offset(
                x: (columnWidth - barWidth) / 2,
                y: CGFloat(startHours) * hourHeight
            )
    }

    /// Faint line at each hour boundary, including one at the bottom edge.
    private func hourLines(contentWidth: CGFloat) -> some View {
        Canvas { context, size in
            for index in 0...hours.count {
                let y = CGFloat(index) * hourHeight
                var path = SwiftUI.Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(
                    path,
                    with: .color(Color.primary.opacity(index == 0 ? 0.18 : 0.10)),
                    lineWidth: 0.6
                )
            }
        }
        .frame(width: contentWidth, height: gridHeight)
        .allowsHitTesting(false)
    }
}

#Preview {
    ScrollView {
        DayAvailabilityView(
            date: Date(),
            members: TestGroup(code: "ABCD67", name: "CODZEE").members,
            calendar: .current
        )
        .padding()
    }
}
