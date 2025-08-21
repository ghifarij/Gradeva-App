//
//  PendingGradesView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct PendingGradesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pending Grades")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            ZStack {
                Image("pending-grades-bg")
                    .scaledToFill()
                VStack {
                    Text("6 awaiting")
                        .font(.title3)
                        .foregroundStyle(.white)
                    Text("your review")
                        .font(.title3)
                        .foregroundStyle(.white)

                    Button(action: {}) {
                        Label("Grade here", systemImage: "clipboard")
                            .foregroundStyle(Color.appPrimary)
                    }
                    .frame(minHeight: 44)
                    .frame(minWidth: 176)
                    .background(.white)
                    .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 144)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PendingGradesView()
}
