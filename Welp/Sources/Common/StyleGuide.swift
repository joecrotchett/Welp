//
//  StyleGuide.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//


import UIKit

struct StyleGuide {
    @MainActor static func apply(to window: UIWindow) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.WelpGrey]

        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    struct Colors {
        static let WelpGrey = UIColor(0x221f20)
    }
}

// MARK: UIColor

extension UIColor {

    convenience init(_ hex: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

