//
//  ContentView.swift
//  AllYourBase
//
//  Hosts the base tabs. A single `AllYourBaseModel` is shared across every
//  tab, exactly like the original app (which passed one `AllYourBaseModel`
//  to every per-base view controller): switching tabs re-renders the same
//  in-progress calculation in the newly selected base.
//
//  Ported from the base lists built in `AllYourBaseAppDelegate_iPhone` (2-16)
//  and `AllYourBaseAppDelegate_iPad` (2-36). Those two app delegates existed
//  only to pick which of those lists to use; now that there's a single
//  SwiftUI target, this uses the fuller iPad list on every device (SwiftUI's
//  `TabView` already collapses overflow tabs into a "More" tab on compact
//  size classes). The original also had a duplicate "Base 10*" tab (an
//  `AllYourBaseViewController` initialized with `base == 0`); it behaved
//  identically to the regular "Base 10" tab in every way except its title,
//  so it has been dropped as dead functionality.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = AllYourBaseModel(base: 10)
    @State private var selectedBase = 10

    private let bases: [Int] = {
        var ordered = [10, 6, 7, 9, 16, 25, 36]
        for base in 2..<37 where !ordered.contains(base) {
            ordered.append(base)
        }
        return ordered
    }()

    var body: some View {
        TabView(selection: $selectedBase) {
            ForEach(bases, id: \.self) { base in
                CalculatorView(model: model)
                    .tabItem { Text("Base \(base)") }
                    .tag(base)
            }
        }
        .onChange(of: selectedBase) { newBase in
            model.setBase(newBase)
        }
    }
}

#Preview {
    ContentView()
}
