import SwiftUI

struct WeView: View {
    @State var textSize = TextSize()
    @State var sizing = Spacing()
    @State var searchQuery = ""
    @State var countPicker: Int = 0
    @State var Groups = [
        TestGroups(name: "two", peopleCount: 2),
        TestGroups(name: "three", peopleCount: 3),
        TestGroups(name: "four", peopleCount: 4),
        TestGroups(name: "five", peopleCount: 5),
        TestGroups(name: "two2", peopleCount: 2),
        TestGroups(name: "three2", peopleCount: 3),
        TestGroups(name: "four2", peopleCount: 4),
        TestGroups(name: "two3", peopleCount: 2),
        TestGroups(name: "three3", peopleCount: 3)
    ]
    var results: [TestGroups] {
        var filtered = Groups
            // Filter 2: Apply search text filter
            if !searchQuery.isEmpty {
                filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
            }
        if !(countPicker == 0) {
                filtered = filtered.filter { $0.peopleCount == countPicker }
            }
        return filtered
    }
    @FocusState var isFocused: Bool
    var body: some View {
        ZStack {
            Color(red: 1, green: 1, blue: 1)
                .ignoresSafeArea()
                .onTapGesture { isFocused = false }
            VStack {
                HStack {
                    TextField("Name", text: $searchQuery)
                        .textFieldStyle(.roundedBorder)
                    Divider()
                        .scaledToFit()
                        .overlay(Color.black)
                        .frame(width: 5, height: 30)
                        .padding(.horizontal, sizing.x1)
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: sizing.x3)
                    Picker("Headcount", selection: $countPicker) {
                            Text("N/A")
                                .tag(0)
                        ForEach(2...10, id: \.self) { x in
                                    Text("\(x)")
                                .tag(x)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.15))
                            )
                } .padding(sizing.x3)
                LazyVStack() {
                    ForEach(results, id: \.self){ testGroup in
                        Text("\(testGroup.name), \(testGroup.peopleCount)")
                            .font(.system(size: textSize.x4))
                        
                    } .searchable(text: $searchQuery)
                }
                Spacer()
            }
            
        }
    }
        
}

#Preview {
    WeView()
}
