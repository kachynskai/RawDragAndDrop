//
//  ShelfVM.swift
//  RawDragAndDropProj
//

import Combine

final class ShelfVM: ObservableObject {
    @Published var readingBooks: [Book] = []
    @Published var finishedBooks: [Book] = []
    
    func fetchData() {
        self.readingBooks = StorageService.shared.fetchBooks(by: .reading)
        self.finishedBooks = StorageService.shared.fetchBooks(by: .finished)
    }
}
