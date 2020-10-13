//
//  ActionButtonStyle.swift
//  graphql
//
//  Created by Hesham Salman on 10/12/20.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.secondary : Color.primary)
            .cornerRadius(grid(3))
    }
}

