//
//  AllYourBaseApp.swift
//  AllYourBase
//
//  Swift/SwiftUI replacement for AllYourBaseAppDelegate_iPhone.m /
//  AllYourBaseAppDelegate_iPad.m + MainWindow_i{Phone,Pad}.xib. The original
//  put one base per `UITabBarController` tab; on iPad that's 37 tabs, which
//  iOS collapses into an awkward "More" list past the first 5. A `Picker`
//  scales to that many options far better than a tab bar, so this presents
//  a single calculator screen with a base picker above it instead - one
//  `CalculatorModel` shared across every base selection exactly like the
//  original shared it across every tab.
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
    /// The base list's first entry (see `BaseCatalog`) - matches the
    /// original's default-selected first tab on both idioms.
    @State private var selectedBase = 10

    private var bases: [Int] {
        UIDevice.current.userInterfaceIdiom == .pad ? BaseCatalog.iPadBases : BaseCatalog.iPhoneBases
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Base", selection: $selectedBase) {
                ForEach(bases, id: \.self) { base in
                    Text("Base \(base)").tag(base)
                }
                // `0` is the classic-layout sentinel, matching the
                // original's `base:0` "Base 10*" tab and
                // `CalculatorScreenView.isClassic` below.
                Text("Base 10*").tag(0)
            }
            .pickerStyle(.menu)
            .font(.title2)
            .padding()

            CalculatorScreenView(
                model: model,
                base: selectedBase == 0 ? 10 : selectedBase,
                isClassic: selectedBase == 0
            )
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
