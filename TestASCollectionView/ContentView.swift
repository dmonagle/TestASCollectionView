//
//  ContentView.swift
//  TestASCollectionView
//
//  Created by David Monagle on 26/5/20.
//  Copyright © 2020 David Monagle. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct ContentView: View {
    @State var selectedNumber: Int = 0

    /// Binding for the animated slider
    private var animatedSliderBinding: Binding<Double> {
        .init(
            get: { Double(self.selectedNumber) },
            set: { newValue in
                withAnimation {
                    self.selectedNumber = Int(newValue)
                }
            }
        )
    }

    /// Binding for the non-animated slider
    private var sliderBinding: Binding<Double> {
        .init(
            get: { Double(self.selectedNumber) },
            set: { newValue in
                self.selectedNumber = Int(newValue)
            }
        )
    }

    
    var data: [CollectionSection: [Datum]] {
        var result = [CollectionSection: [Datum]]()

        result[CollectionSection(name: "Divisible by 1")] = Datum.build(for: 1 + selectedNumber)
        
        if selectedNumber % 2 == 0 {
            result[CollectionSection(name: "Divisible by 2")] = Datum.build(for: 2 + selectedNumber)
        }
        
        if selectedNumber % 3 == 0 {
            result[CollectionSection(name: "Divisible by 3")] = Datum.build(for: 2 + selectedNumber)
        }
        

        return result
    }
    
    var body: some View {
        VStack {
            ASCollectionView(sections: self.sections)
                .layout(self.layout)
                .frame(height: 200)
            Text("Number: \(selectedNumber)")
                .font(.headline)
            Form {
                Section(header: Text("These non animated controls should be safe.")) {
                    Button(action: {
                        self.selectedNumber = (0...20).randomElement() ?? 0}
                    ) {
                        Text("Shuffle without animation")
                    }
                    Slider(value: self.sliderBinding, in: 0.0 ... 20.0, step: 1.0)
                }
                Section(header: Text("These animated controls will eventually lockup (and eventually crash) the app.")) {
                    Button(action: {
                        withAnimation {
                            self.selectedNumber = (0...20).randomElement() ?? 0}
                        }
                    ) {
                        Text("Shuffle with animation")
                    }
                    Slider(value: self.animatedSliderBinding, in: 0.0 ... 20.0, step: 1.0)
                }
            }
            Spacer()
        }
    }
    
    var sections: [ASCollectionViewSection<CollectionSection>] {
        data.map { (section, colors) in
            ASCollectionViewSection(id: section, data: colors, dataID: \.self) { color, _ in
                Text(color.description)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(color.color)
            }
            .sectionHeader {
                sectionHeader(for: section)
            }
        }
    }

    func sectionHeader(for section: CollectionSection) -> some View {
        GeometryReader { geometry in
            Text(section.name)
                .font(.headline)
                .foregroundColor(.secondary)
                .rotationEffect(.degrees(-90))
                .frame(width: geometry.size.height, height: geometry.size.width)
        }
    }
    
    var layout: ASCollectionLayout<CollectionSection> {
    ASCollectionLayout(scrollDirection: .horizontal, interSectionSpacing: 0) { sectionID in
            ASCollectionLayoutSection { environment in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.5)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let stack = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalHeight(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    ),
                    subitem: item,
                    count: 2
                )
                stack.interItemSpacing = .fixed(16.0)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [stack]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
                section.interGroupSpacing = 16
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(44),
                    heightDimension: .fractionalHeight(1.0)
                )

                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader, alignment: .leading
                )
                
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Data

struct CollectionSection: Hashable {
    var name: String
}

enum Datum: Int, Hashable, CustomStringConvertible {
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .indigo:
            return Color(.systemIndigo)
        }
    }
    
    var description: String {
        switch self {
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        case .yellow:
            return "Yellow"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .indigo:
            return "Indigo"
        }
    }
    
    static func build(for number: Int) -> [Self] {
        var result = [Self]()
        
        result.append(.red)
        if number % 2 == 0 { result.append(.orange)}
        if number % 3 == 0 { result.append(.yellow)}
        if number % 4 == 0 { result.append(.green)}
        if number % 5 == 0 { result.append(.blue)}
        if number % 6 == 0 { result.append(.indigo)}

        return result
    }
}

