//
//  badviwe.swift
//  Hang
//
//  Created by T Krobot on 13/11/26.
//

import SwiftUI

struct badviwe: View {
    var body: some View {
        VStack(alignment: .center, spacing: -8) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.clear, .black],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )

                Text("namemads")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(8)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "birthday.cake.fill")
                    Text("67")
                        .font(.callout)
                        .bold()
                }
                Divider()
                    .frame(height: 20)
                    .padding(4)
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                    Text("33qw")
                        .font(.callout)
                        .bold()
                }
            }
            .padding(8)
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 6, x: 3, y: 3)
    }
}

#Preview {
    badviwe()
}
