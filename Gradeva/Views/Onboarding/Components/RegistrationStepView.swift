//
//  RegistrationStepView.swift
//  Gradeva
//
//  Created by Claude on 20/08/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct RegistrationStepView: View {
    @StateObject private var registration = RegistrationManager()
    @ObservedObject private var auth = AuthManager.shared
    
    var registrationLink: String {
        if let registrationId = registration.myRegistration?.id {
            return "https://gradeva.muhammadramdan.com/register/\(registrationId)"
        }
        return "https://gradeva.muhammadramdan.com/not-found"
    }
    
    func handleCopyLink() {
        UIPasteboard.general.setValue(registrationLink, forPasteboardType: UTType.plainText.identifier)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Header icon
            Image(systemName: "building.2")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
                .accessibilityHidden(true)
            
            // Title and description
            VStack(spacing: 12) {
                Text("School Registration")
                    .font(.title2)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                
                Text("To access Gradeva, you need to be registered with a school. Please share the link below with your school administrator.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .accessibilityAddTraits(.isStaticText)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("School Registration. To access Gradeva, you need to be registered with a school. Please share the link below with your school administrator.")
            .accessibilityAddTraits(.isHeader)
            
            // Registration link section
            VStack(spacing: 16) {
                Text("Registration Link")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                Button(action: handleCopyLink) {
                    HStack(spacing: 12) {
                        Text(registrationLink)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .font(.caption)
                        
                        Image(systemName: "document.on.document")
                            .font(.system(size: 16))
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .accessibilityLabel("Copy registration link")
                .accessibilityHint("Double tap to copy the registration link to clipboard")
                .accessibilityAddTraits(.isButton)
                .accessibilityValue(registrationLink)
            }
            
            // Demo option note
            Text("You can also try with demo data by tapping the \"Try Demo School\" below")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isStaticText)
            
            Spacer()
        }
    }
}

#Preview {
    RegistrationStepView()
}
