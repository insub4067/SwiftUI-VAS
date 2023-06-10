//
//  ContentView.swift
//  TEST
//
//  Created by 김인섭 on 2023/06/02.
//

import SwiftUI

struct ContentView: MVA {
    
    typealias Action = ContentViewAction
    typealias Model = ContentViewModel
    
    @StateObject var model: Model
    let action: Action
    
    @Namespace var animation
    let columns: [GridItem] = Array(repeating: .init(), count: 3)
    let items: [String] = Array(repeating: .init(), count: 100)

    var body: some View {
        VStack(spacing: 0) {
            TabBar()
            Content()
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(
                        model.currentTab == tab ?
                        .title2 : .title3
                    )
                    .foregroundColor(
                        model.currentTab == tab ?
                        .black : .gray
                    )
                    .padding()
                    .background(alignment: .bottom) {
                        if model.currentTab == tab {
                            Color
                                .black
                                .frame(maxWidth: .infinity)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "underline", in: animation)
                        }
                    }
                    .onTapGesture {
                        action
                            .didTapTab(tab: tab)
                    }
            }
        }
        .background(alignment: .bottom) {
            Color
                .gray
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func Content() -> some View {
        
        TabView(selection: $model.currentTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.offset) { offset, item in
                            Text("\(offset)")
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(alignment: .bottom) {
                                    Color
                                        .gray
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                }
                            
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    static func build() -> some View {

        let model = ContentViewModel()
        let action = ContentViewAction()
        action.model = model

        return ContentView
            .init(
                model: model,
                action: action
            )
    }
}

enum TabItem: String, CaseIterable {
    
    case one, two, three
    
    var background: Color {
        switch self {
        case .one:
            return .brown
        case .two:
            return .blue
        case .three:
            return .yellow
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView
                .build()
        }
    }
}