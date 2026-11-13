import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupName = ""
    @State private var code = ""
    @Binding var tgs: [TestGroup]

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                TextField("Group name", text: $groupName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.capsule)

                VStack {
                    Text("Invite friends with code")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        ForEach(0..<6, id: \.self) { index in
                            otpDigitBox(at: index)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Create Group")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        tgs.append(TestGroup(code: code, name: groupName))
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // TODO: keep generating until the code is not already in Firestore.
            code = generateRandomCode()
        }
    }

    @ViewBuilder
    private func otpDigitBox(at index: Int) -> some View {
        let character = characterAt(index)

        Text(character)
            .font(.title2.bold())
            .frame(width: 30, height: 40)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }

    private func characterAt(_ index: Int) -> String {
        guard index < code.count else { return "" }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[stringIndex])
    }

    private func generateRandomCode(length: Int = 6) -> String {
        let characters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String(
            (0..<length).compactMap { _ in characters.randomElement() }
        )
    }
}

#Preview {
    CreateGroupView(tgs: .constant([]))
}
