//
//  ContentView.swift
//  AllYourBase
//
//  Single-view calculator with picker-based base selection. A single
//  `AllYourBaseModel` renders the same in-progress calculation in whichever
//  base is currently selected. This replaces the original 35-tab TabView with
//  a more compact UI that allows quick base switching without scrolling through
//  tabs.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = AllYourBaseModel(base: 10)

    var body: some View {
        VStack(spacing: 0) {
            // Base selector at top
            BasePickerView(selectedBase: Binding(
                get: { model.base },
                set: { model.setBase($0) }
            ))
            .padding()

            Divider()

            // Calculator interface
            CalculatorView(model: model)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Base Picker

struct BasePickerView: View {
    @Binding var selectedBase: Int

    let commonBases = [2, 8, 10, 16]
    @State private var showingAllBases = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Number Base")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ForEach(commonBases, id: \.self) { base in
                    BaseButton(base: base, isSelected: selectedBase == base) {
                        selectedBase = base
                    }
                }

                Button {
                    showingAllBases = true
                } label: {
                    Text("More...")
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 70, height: 44)
                }
                .buttonStyle(.bordered)
                .tint(selectedBase > 16 ? .accentColor : .secondary)
            }
        }
        .sheet(isPresented: $showingAllBases) {
            AllBasesView(selectedBase: $selectedBase, isPresented: $showingAllBases)
        }
    }
}

struct BaseButton: View {
    let base: Int
    let isSelected: Bool
    let action: () -> Void

    var baseName: String {
        switch base {
        case 2: return "BIN"
        case 8: return "OCT"
        case 10: return "DEC"
        case 16: return "HEX"
        default: return "\(base)"
        }
    }

    var body: some View {
        Button(action: action) {
            Text(baseName)
                .font(.system(.body, design: .monospaced))
                .fontWeight(isSelected ? .bold : .regular)
                .frame(width: 70, height: 44)
        }
        .buttonStyle(.bordered)
        .tint(isSelected ? .accentColor : .secondary)
    }
}

struct AllBasesView: View {
    @Binding var selectedBase: Int
    @Binding var isPresented: Bool

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(2...36, id: \.self) { base in
                        Button {
                            selectedBase = base
                            isPresented = false
                        } label: {
                            Text("\(base)")
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(selectedBase == base ? .bold : .regular)
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.bordered)
                        .tint(selectedBase == base ? .accentColor : .secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Select Base")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
