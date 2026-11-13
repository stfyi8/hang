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
    @State private var selectedGroupTab: GroupTab = .info

    var body: some View {
        NavigationStack {
            ZStack {
                // colors.green1
                // .ignoresSafeArea()
                VStack {
                    Picker("Picker", selection: $selectedGroupTab) {
                        ForEach(GroupTab.allCases) {
                            gtab in
                            Text(gtab.rawValue)
                        }
                    }
                    .padding()
                    .pickerStyle(.segmented)
                    if selectedGroupTab == .cal {
                        CalendarView(tg: $tg)
                            .padding()
                    } else if selectedGroupTab == .events {
                        EventView(tg: $tg)
                    } else if selectedGroupTab == .info {
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
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    //                    .fill(colors.green2)
                    .frame(height: 300)
                Text("calendar goes here")
                    .bold()
                //                    .foregroundStyle(colors.txt2)
            }
            .padding(.vertical)

            Spacer()
        }
    }
}

struct EventView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup
    var body: some View {
        //        VStack {
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
        }.padding(.top, -sizing.x4)
        .scrollContentBackground(.hidden)

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
