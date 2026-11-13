import SwiftUI

struct JoinGroupView: View {
    let codeLength = 6
    @State var groupname: String = ""
    @State var code: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Enter group code")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                ZStack {
                    HStack(spacing: 4) {
                        ForEach(0..<codeLength, id: \.self) { index in
                            otpDigitBox(at: index)
                        }
                    }

                    TextField("", text: $code)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)  // Enables iOS SMS AutoFill
                        .focused($isFocused)
                        .accentColor(.clear)
                        .foregroundColor(.clear)
                        .background(Color.clear)
                        .onChange(of: code) { _, newValue in
                            code = String(newValue.prefix(codeLength)).uppercased()
                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
                .onAppear {
                    isFocused = true
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Join Group")
            .toolbar {
                // Top-right button with SF Symbol
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        // Add action
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func otpDigitBox(at index: Int) -> some View {
        let character = characterAt(index)
        let isCurrentBox =
            isFocused
            && (index == code.count
                || (index == codeLength - 1 && code.count == codeLength))

        Text(character)
            .font(.title2.bold())
            .frame(width: 30, height: 40)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isCurrentBox ? Color.accentColor : Color.clear,
                        lineWidth: 2
                    )
            )
    }

    private func characterAt(_ index: Int) -> String {
        guard index < code.count else { return "" }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[stringIndex])
    }
}

#Preview {
    JoinGroupView()
}
