//
//  Haptics.swift
//  Todo_hackathon
//
//  Created by Radhika on 22/02/26.
//

import UIKit

enum Haptics {

    static func taskToggled() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func taskDeleted() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
