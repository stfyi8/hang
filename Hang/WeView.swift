import SwiftUI

struct WeView: View {
    var sizing = Sizing()
    var colors = Colors()
    @State var searchQuery = ""
    @State var countPicker: Int = 0
    @State var Groups = [
        TestGroup(name: "two", peopleCount: 2),
        TestGroup(name: "three", peopleCount: 3),
        TestGroup(name: "four", peopleCount: 4),
        TestGroup(name: "five", peopleCount: 5),
        TestGroup(name: "two2", peopleCount: 2),
        TestGroup(name: "three2", peopleCount: 3),
        TestGroup(name: "four2", peopleCount: 4),
        TestGroup(name: "two3", peopleCount: 2),
        TestGroup(name: "three3", peopleCount: 3)
    ]
    @State var showingCreateSheet = false
    @State var showingJoinSheet = false
    var results: [TestGroup] {
        var filtered = Groups
        // Filter 2: Apply search text filter
        if !searchQuery.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        if !(countPicker == 0) {
            filtered = filtered.filter { $0.peopleCount == countPicker }
        }
        return filtered
    }
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    @FocusState var isFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: sizing.x1) {
                        ForEach(results) { tg in
                            if let index = Groups.firstIndex(where: { $0.id == tg.id }) {
                                        NavigationLink {
                                            GroupView(tg: $Groups[index])
                                        } label: {
                                            GroupCard(tg: tg)
                                        }
                                        .buttonStyle(setStyle(styleName: .Shrink2))
                                    }
                        }
                    }
                    .padding()
                    .ignoresSafeArea()
                    .searchable(
                        text: $searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always)
                    )
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateGroupView()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingJoinSheet) {
                JoinGroupView()
                    .presentationDetents([.medium])
            }
            .navigationTitle("Groups")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Profile", systemImage: "person.fill") {
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button("Create", systemImage: "star") {
                            showingCreateSheet = true
                        }
                        Button("Join", systemImage: "person.badge.plus") {
                            showingJoinSheet = true
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }

}

struct GroupCard: View {
    var sizing = Sizing()
    var colors = Colors()
    let tg: TestGroup
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(colors.green)
                .aspectRatio(1, contentMode: .fit)
            VStack(alignment: .leading) {
                Text(tg.name)
                    .font(.system(size: sizing.x6, weight: .bold))
                    .foregroundStyle(colors.txt1)
                    .padding(.bottom, -sizing.x1)
                Divider()
                    .frame(height: 1)
                    .overlay(colors.obj)
                Text(tg.desc)
                        .font(.system(size: sizing.x3))
                        .lineLimit(1)
                        .foregroundStyle(colors.txt2)
                HStack {
                    Text("\(tg.peopleCount)")
                        .font(.system(size: sizing.x3, weight: .bold))
                        .foregroundStyle(colors.txt2)
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(colors.txt2)
                        .frame(width: sizing.x4)
                }
            }
            .padding(.vertical, sizing.x3)
            .padding(.horizontal, sizing.x4)
        } .padding(sizing.x1)
    }
}

#Preview {
    WeView()
}

/*
HStack {
    Image(systemName: "calendar")
        .resizable()
        .scaledToFit()
        .foregroundStyle(colors.obj)
        .frame(width: sizing.x3)
    Text(Date(timeIntervalSince1970: tg.time).formatted(date: .numeric, time: .omitted))
        .font(.system(size: sizing.x3))
        .foregroundStyle(colors.txt2)
}
HStack {
    Image(systemName: "clock")
        .resizable()
        .scaledToFit()
        .foregroundStyle(colors.obj)
        .frame(width: sizing.x3)
    Text(Date(timeIntervalSince1970: tg.time).formatted(date: .omitted, time: .shortened))
        .font(.system(size: sizing.x3))
        .foregroundStyle(colors.txt2)
}
*/
