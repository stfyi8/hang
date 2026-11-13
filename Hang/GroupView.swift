import SwiftUI

public enum GroupTab : String, CaseIterable, Identifiable {
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
                colors.bg1
                    .ignoresSafeArea()
                VStack {
                    Picker("Picker", selection: $selectedGroupTab) {
                        ForEach(GroupTab.allCases) {
                            gtab in
                            Text(gtab.rawValue)
                            
                            
                        }
                    }
                    .pickerStyle(.segmented)
                    if selectedGroupTab == .cal {
                        CalendarView(tg: $tg)
                    } else if selectedGroupTab == .events {
                        EventView(tg: $tg)
                    } else if selectedGroupTab == .info {
                        MoreInfoView(tg: $tg)
                    }
                }
                .padding()
                .navigationTitle(tg.name)
            }
        }
    }
}

#Preview {
    GroupView(tg: .constant(TestGroup(name: "two", peopleCount: 2)))
}

struct CalendarView: View {
    var sizing = Sizing()
    var colors = Colors()
    @Binding var tg: TestGroup
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(colors.bg2)
                    .frame(height: 300)
                Text("calendar goes here")
                    .bold()
                    .foregroundStyle(colors.txt2)
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
        VStack {
            List {
                ForEach($tg.events) { $event in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(event.name)
                                .font(.system(size: sizing.x4))
                            Divider()
                                .frame(width: 1)
                                .overlay(.black)
                            Text(Date(timeIntervalSince1970: event.time).formatted(date: .numeric, time: .shortened))
                                .font(.system(size: sizing.x4))
                            
                        }
                        Text(event.desc)
                            .font(.system(size: sizing.x3))
                            .lineLimit(1)
                        
                    }
                    .listRowBackground(colors.bg2)
                    
                    
                    
                }
            }
            .padding(.horizontal, -sizing.x2)
            .scrollContentBackground(.hidden)
            
            Spacer()
        }
    }
}

struct MoreInfoView: View {
    @Binding var tg: TestGroup
    var body: some View {
        VStack {
            
            Spacer()
        }
    }
}

