//
//  NotRegisteredView.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct NotRegisteredView: View {
    @StateObject private var registration = RegistrationManager()
    @EnvironmentObject private var auth: AuthManager
    
    var registrationLink: String {
        if let registrationId = registration.myRegistration?.id {
            return "https://gradeva.muhammadramdan.com/register/\(registrationId)"
        }
        return "https://gradeva.muhammadramdan.com/register"
    }
    
    func handleCopyLink() {
        UIPasteboard.general.setValue(registrationLink, forPasteboardType: UTType.plainText.identifier)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.accentColor)
            Text("Hi there! It seems you do not belong to any school")
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 30)
            
            Divider()
            
            Spacer()
                .frame(height: 30)
            
            Text("Copy this link and give to your school administrator")
                .multilineTextAlignment(.center)
            
            Button(action: handleCopyLink) {
                HStack {
                    Text(registrationLink)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Image(systemName: "document.on.document")
                        .resizable()
                        .frame(width: 20, height: 24)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
            
            Button(action: auth.signOut) {
                Text("Sign Out")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Button(action: registration.registerToDemo) {
                Text("Try with Demo School")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}

#Preview {
    NotRegisteredView()
}
