//
//  ArchiveListsView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct ShelfListsView: View {
    @StateObject private var shelfVM = ShelfVM()
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        ShelfSectionView(title: "Читаю зараз", books: shelfVM.readingBooks, color: .blue)
                        
                        ShelfSectionView(title: "Прочитано", books: shelfVM.finishedBooks, color: .green)
                    }
                    .padding()
                }
            }
            .navigationTitle("Прогрес")
            .onAppear {
                shelfVM.fetchData()
            }
        }
    }
}

#Preview {
    ShelfListsView()
}
