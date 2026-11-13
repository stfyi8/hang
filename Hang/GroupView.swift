import SwiftUI

public enum GroupTab : String, CaseIterable, Identifiable {
    case cal = "Calendar"
    case events = "Events"
    case info = "More Info"
    
    public var id: Self { self }
}

struct GroupView: View {
    @State private var selectedGroupTab: GroupTab = .cal

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Picker", selection: $selectedGroupTab) {
                    ForEach(GroupTab.allCases) {
                        gtab in
                        Text(gtab.rawValue)
                        
                        
                    }
                }
                .pickerStyle(.segmented)
                if selectedGroupTab == .cal {
                    CalendarView()
                } else if selectedGroupTab == .events {
                    EventView()
                } else if selectedGroupTab == .info {
                    MoreInfoView()
                }
            }
            .padding()
            .navigationTitle("Order of the Rolling J")
        }
    }
}

#Preview {
    GroupView()
}

struct CalendarView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.green)
                    .frame(height: 300)
                Text("calendar goes here")
                    .bold()
                    .foregroundStyle(.white)
            }
            .padding(.vertical)

            Spacer()
        }
    }
}

struct EventView: View {
    var body: some View {
        NavigationStack {
            
            Spacer()
        }
    }
}

struct MoreInfoView: View {
    var body: some View {
        NavigationStack {
            
            Spacer()
        }
    }
}
