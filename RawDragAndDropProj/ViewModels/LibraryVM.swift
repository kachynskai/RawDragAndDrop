//
//  LibraryVM.swift
//  RawDragAndDropProj
//

import Combine
import Foundation

final class LibraryVM: ObservableObject {
    @Published var bookList: [Book] = []
    @Published var isShowingSearch = false
    
    func fetchBooks() {
        self.bookList = StorageService.shared.fetchAllBooks()
    }
    
    func deleteBook(at offsets: IndexSet) {
        offsets.map { bookList[$0] }.forEach { book in
            StorageService.shared.deleteBook(book)
        }
        fetchBooks()
    }
}
