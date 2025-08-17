//  FirstTimeRegistrationOnboardingView.swift
//  Gradeva
//
//  Created by Copilot on 17/08/25.
//

import SwiftUI

struct FirstTimeRegistrationOnboardingView: View {
    let registrationId: String
    @State private var copied = false
    
    var registrationLink: String {
        "https://gradeva.muhammadramdan.com/register/\(registrationId)"
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)
            Text("Welcome to Gradeva!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("To get started, you need to register with your school. Please follow these steps:")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Text("1.")
                        .fontWeight(.bold)
                    Text("Copy your registration link below.")
                }
                HStack(alignment: .top) {
                    Text("2.")
                        .fontWeight(.bold)
                    Text("Send the link to your school administrator.")
                }
                HStack(alignment: .top) {
                    Text("3.")
                        .fontWeight(.bold)
                    Text("Wait for your registration to be approved. You will be notified once you can access the app.")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            VStack(spacing: 8) {
                Text(registrationLink)
                    .font(.callout)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = registrationLink
                            copied = true
                        }) {
                            Label("Copy Link", systemImage: "doc.on.doc")
                        }
                    }
                Button(action: {
                    UIPasteboard.general.string = registrationLink
                    copied = true
                }) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text(copied ? "Copied!" : "Copy Link")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: copied)
    }
}

#Preview {
    FirstTimeRegistrationOnboardingView(registrationId: "sample1234")
}
