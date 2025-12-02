//
//  ArchiveListsView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct ShelfListsView: View {
    @StateObject private var shelfVM = ShelfVM()
    @State private var draggedBook: Book?
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        ShelfSectionView(title: "Читаю зараз", books: shelfVM.readingBooks, color: .blue,
                                         status: .reading, viewModel: shelfVM, draggedBook: $draggedBook)
                        
                        ShelfSectionView(title: "Прочитано", books: shelfVM.finishedBooks, color: .green,
                                         status: .finished, viewModel: shelfVM, draggedBook: $draggedBook)
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
