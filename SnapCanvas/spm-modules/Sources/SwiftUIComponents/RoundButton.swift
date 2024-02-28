//
//  RoundButton.swift
//
//
//  Created by Mohanna Zakizadeh on 2/25/24.
//

import SwiftUI

@available(iOS 16.0, *)

public struct RoundButton: View {
    public var backgroundColor: Color
    public var foregroundColor: Color
    public var identifier: String
    public var imageName: String
    public var action: () -> Void
    
    public init(backgroundColor: Color, foregroundColor: Color, identifier: String, imageName: String, action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.identifier = identifier
        self.imageName = imageName
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 15, weight: .none))
                .foregroundColor(foregroundColor)
                .padding()
                .background(backgroundColor)
                .clipShape(Circle()) // Clip the background to a circle
        }
        .accessibilityIdentifier(identifier)
    }
}

@available(iOS 16.0, *)
#Preview {
    RoundButton(backgroundColor: .accentColor, foregroundColor: .white, identifier: "hi", imageName: "photo", action: {
        
    })
}
