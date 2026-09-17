//
//  AllYourBaseApp.swift
//  AllYourBase
//
//  Swift/SwiftUI replacement for AllYourBaseAppDelegate_iPhone.m /
//  AllYourBaseAppDelegate_iPad.m + MainWindow_i{Phone,Pad}.xib. Builds one
//  `UITabBarController`-equivalent `TabView`, one tab per base, sharing a
//  single `CalculatorModel` across every tab exactly like the original did.
//

import SwiftUI
import UIKit

enum BaseCatalog {
    /// Reproduces the original's dedupe-preserving-first-occurrence base
    /// list building (`NSMutableArray *bases = ...; for (i = 2; i < N; i++)
    /// if (![bases containsObject:i]) [bases addObject:i];`).
    static func bases(preferredFirst: [Int], upTo exclusiveUpperBound: Int) -> [Int] {
        var bases = preferredFirst
        for candidate in 2..<exclusiveUpperBound where !bases.contains(candidate) {
            bases.append(candidate)
        }
        return bases
    }

    /// iPhone: bases 2...16, "Base 10" shown first (AllYourBaseAppDelegate_iPhone.m).
    static let iPhoneBases = bases(preferredFirst: [10, 6, 7, 12], upTo: 17)

    /// iPad: bases 2...36 (AllYourBaseAppDelegate_iPad.m).
    static let iPadBases = bases(preferredFirst: [10, 6, 7, 9, 16, 25, 36], upTo: 37)
}

struct ContentView: View {
    @StateObject private var model = CalculatorModel()

    private var bases: [Int] {
        UIDevice.current.userInterfaceIdiom == .pad ? BaseCatalog.iPadBases : BaseCatalog.iPhoneBases
    }

    var body: some View {
        TabView {
            ForEach(bases, id: \.self) { base in
                CalculatorScreenView(model: model, base: base, isClassic: false)
                    .tabItem { Text("Base \(base)") }
                    .tag(base)
            }
            CalculatorScreenView(model: model, base: 10, isClassic: true)
                .tabItem { Text("Base 10*") }
                .tag(0)
        }
    }
}

@main
struct AllYourBaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
