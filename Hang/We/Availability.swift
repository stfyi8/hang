//
//  Availability.swift
//  Hang
//
//  Availability data used to drive the calendar heatmap and the per-member
//  timeline. Busy intervals are currently mock data so the same day always
//  looks the same. In a real app the busy intervals would come from each
//  member's calendar via EventKit.
//

import SwiftUI

extension Person {
    /// Stable per-member colour used for avatars and busy blocks.
    var tint: Color {
        let palette: [Color] = [
            .teal, .indigo, .orange, .pink, .purple, .blue, .mint,
        ]
        return palette[scheduleSeed % palette.count]
    }

    /// Stable offset so each member gets a different (but repeatable) schedule.
    var scheduleSeed: Int {
        // Derive the seed from the name so it stays the same across launches.
        name.unicodeScalars.reduce(0) { $0 + Int($1.value) }
    }
}

/// The part of the day that availability is compared over.
enum AvailabilityDay {
    static let startHour = 8
    static let endHour = 22
}

struct AvailabilityCalculator {
    var calendar: Calendar = .current

    /// The comparable hours for a given day, e.g. 8:00 to 22:00.
    func window(for date: Date) -> DateInterval {
        let dayStart = calendar.startOfDay(for: date)
        let start =
            calendar.date(
                byAdding: .hour,
                value: AvailabilityDay.startHour,
                to: dayStart
            ) ?? dayStart
        let end =
            calendar.date(
                byAdding: .hour,
                value: AvailabilityDay.endHour,
                to: dayStart
            ) ?? dayStart
        return DateInterval(start: start, end: end)
    }

    /// Busy intervals that fall inside the availability window.
    func busyIntervals(for member: Person, on date: Date) -> [DateInterval] {
        let window = window(for: date)
        return member.mockBusyIntervals(on: date, calendar: calendar)
            .compactMap { busy in
                let start = max(busy.start, window.start)
                let end = min(busy.end, window.end)
                guard start < end else { return nil }
                return DateInterval(start: start, end: end)
            }
    }

    /// The gaps between a member's busy intervals within the availability window.
    func freeIntervals(for member: Person, on date: Date) -> [DateInterval] {
        let window = window(for: date)
        var free = [window]

        for busy in busyIntervals(for: member, on: date) {
            free = free.flatMap { slot in
                guard slot.intersects(busy) else { return [slot] }

                var remaining: [DateInterval] = []
                if slot.start < busy.start {
                    remaining.append(
                        DateInterval(
                            start: slot.start,
                            end: min(busy.start, slot.end)
                        )
                    )
                }
                if busy.end < slot.end {
                    remaining.append(
                        DateInterval(
                            start: max(busy.end, slot.start),
                            end: slot.end
                        )
                    )
                }
                return remaining
            }
        }

        return free.filter { $0.duration > 30 * 60 }
    }

    /// How free the whole group is on a day: 0 = nobody free, 1 = everyone free all day.
    func freeFraction(on date: Date, members: [Person]) -> Double {
        guard !members.isEmpty else { return 0 }

        let dayLength = window(for: date).duration
        guard dayLength > 0 else { return 0 }

        let freeDuration = members.reduce(0.0) { total, member in
            total
                + freeIntervals(for: member, on: date).reduce(0.0) {
                    $0 + $1.duration
                }
        }

        return min(
            1,
            max(0, freeDuration / (dayLength * Double(members.count)))
        )
    }
}

private extension Person {
    /// Deterministic fake calendar data so the same day always looks the same.
    func mockBusyIntervals(on date: Date, calendar: Calendar) -> [DateInterval] {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let isWeekend = calendar.isDateInWeekend(date)
        let patternCount = isWeekend ? 4 : 8
        let pattern = (dayOfYear + scheduleSeed * 3) % patternCount

        let dayStart = calendar.startOfDay(for: date)
        func slot(_ startHour: Int, _ endHour: Int) -> DateInterval {
            let start =
                calendar.date(byAdding: .hour, value: startHour, to: dayStart)
                ?? dayStart
            let end =
                calendar.date(byAdding: .hour, value: endHour, to: dayStart)
                ?? dayStart
            return DateInterval(start: start, end: end)
        }

        switch pattern {
        case 0: return []
        case 1: return [slot(9, 11)]
        case 2: return [slot(13, 15)]
        case 3: return [slot(9, 12), slot(18, 20)]
        case 4: return [slot(16, 22)]
        case 5: return [slot(8, 10), slot(12, 13), slot(15, 17)]
        case 6: return [slot(8, 22)]
        default: return [slot(11, 13), slot(19, 21)]
        }
    }
}
