import SwiftUI

struct CreateGroupView: View {
    @State var groupname: String = ""
    @State var code: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                TextField("Group name", text: $groupname)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.capsule)

                //                Button("Confirm") {
                //                }
                //                .buttonStyle(.glassProminent)
                //                .controlSize(.large)

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
                // Top-right button with SF Symbol
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        // Add action
                    }
                }
            }
        }
        .onAppear {
            var candidateCode = generateRandomCode()
            var uniqueCodeFound = false
            while !uniqueCodeFound {
                // check if its NOT in firebase
                uniqueCodeFound = true
                // else, candidateCode = generateRandomCode()
            }
            // finally, show the REAL code
            code = "ABCD67"  // put real code here
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
    CreateGroupView()
}
