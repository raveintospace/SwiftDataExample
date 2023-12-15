//
//  ButtonStyles.swift
//  SwiftDataExample
//
//  Created by Uri on 15/12/23.
//

import Foundation
import SwiftUI

struct SaveCountryNameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .green : .blue)
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

