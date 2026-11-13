//
//  GroupView.swift
//  Hang
//
//  Created by T Krobot on 11/11/26.
//

import SwiftUI

struct GroupView: View {
    @State private var selectedGroupTab = 0

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Picker", selection: $selectedGroupTab) {
                    Text("Calendar").tag(0)
                    Text("Events").tag(1)
                    Text("Info").tag(2)
                }
                .pickerStyle(.segmented)

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
            .padding()
            .navigationTitle("Order of the Rolling J")
        }
    }
}

#Preview {
    GroupView()
}
