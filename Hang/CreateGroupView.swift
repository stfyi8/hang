//
//  CreateGroupView.swift
//  Hang
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct CreateGroupView: View {
    @State var groupname: String = ""
    @State var code: String = "ABCXYZ"

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
}

#Preview {
    CreateGroupView()
}
