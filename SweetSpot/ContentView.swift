//
//  ContentView.swift
//  SweetSpot
//
//  Created by Dylan Kereluk on 2025-05-13.
//

import SwiftUI

struct CarbMix {
    let maltodextrin: Double
    let fructose: Double
}

func calculateCarbMix(totalGrams: Double, ratio: RatioOption) -> CarbMix {
    let totalParts = ratio.malto + ratio.fructose
    let partSize = totalGrams / totalParts

    let maltodextrin = partSize * ratio.malto
    let fructose = partSize * ratio.fructose

    return CarbMix(maltodextrin: maltodextrin, fructose: fructose)
}

enum RatioOption: String, CaseIterable, Identifiable {
    case oneToPointEight = "1:0.8"
    case twoToOne = "2:1"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .oneToPointEight:
            return "1:0.8"
        case .twoToOne:
            return "2:1"
        }
    }

    var malto: Double {
        switch self {
        case .oneToPointEight: return 1.0
        case .twoToOne: return 2.0
        }
    }

    var fructose: Double {
        switch self {
        case .oneToPointEight: return 0.8
        case .twoToOne: return 1.0
        }
    }
}

import SwiftUI

struct ContentView: View {
    @State private var totalGramsInput: String = ""
    @State private var result: CarbMix?
    @State private var selectedRatio: RatioOption = .oneToPointEight
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Large Title
                    Text("Sweet Spot")
                        .font(.largeTitle.weight(.bold))
                        .padding(.top, 12)

                    // Subtitle with Atom Symbol
                    HStack(spacing: 6) {
                        Text("How much fuel?")
                        Image(systemName: "atom")
                    }
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundStyle(Color.primary.opacity(0.68))

                    // Centered Input Field
                    TextField("Enter total grams", text: $totalGramsInput)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                        )
                        .padding(.horizontal)
                        .focused($isInputFocused)
                    
                    // Ratio Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Carbohydrate Ratio")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Picker("Carbohydrate Ratio", selection: $selectedRatio) {
                            ForEach(RatioOption.allCases) { option in
                                Text(option.description).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)

                    // Calculate Button
                    Button {
                        isInputFocused = false
                        if let total = Double(totalGramsInput) {
                            result = calculateCarbMix(totalGrams: total, ratio: selectedRatio)
                        }
                    } label: {
                        Label("Calculate", systemImage: "function")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray4))
                            )
                    }
                    .padding(.horizontal)

                    // Results Section
                    if let mix = result {
                        VStack(spacing: 12) {
                            HStack {
                                Label("Maltodextrin", systemImage: "circle.hexagongrid")
                                Spacer()
                                Text("\(mix.maltodextrin, specifier: "%.2f") g")
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                Label("Fructose", systemImage: "flask")
                                Spacer()
                                Text("\(mix.fructose, specifier: "%.2f") g")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.subheadline)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                        )
                        .padding(.horizontal)
                    }
                    
                    // Reset Button
                    Button {
                        totalGramsInput = ""
                        result = nil
                        selectedRatio = .oneToPointEight
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray5))
                            )
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
