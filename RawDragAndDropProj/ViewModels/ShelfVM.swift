//
//  ShelfVM.swift
//  RawDragAndDropProj
//

import Combine
import Foundation
import SwiftUI

final class ShelfVM: ObservableObject {
    @Published var readingBooks: [Book] = []
    @Published var finishedBooks: [Book] = []
    
    func fetchData() {
        self.readingBooks = StorageService.shared.fetchBooks(by: .reading)
        self.finishedBooks = StorageService.shared.fetchBooks(by: .finished)
    }
    
    func reorderBooks(from sourceBook: Book, to destinationBook: Book, in status: BookStatus) {
        var booksArray = (status == .reading) ? readingBooks : finishedBooks
        
        guard let fromIndex = booksArray.firstIndex(of: sourceBook),
              let toIndex = booksArray.firstIndex(of: destinationBook) else { return }
        
        booksArray.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)

        if status == .reading {
            readingBooks = booksArray
        } else {
            finishedBooks = booksArray
        }
        
        for (index, book) in booksArray.enumerated() {
            book.sortIndex = Int64(index)
        }

        StorageService.shared.saveData()
    }

    func moveBookBetweenLists(book: Book, to index: Int, targetStatus: BookStatus) {
        if book.readingStatus == .reading {
            readingBooks.removeAll { $0 == book }
        } else {
            finishedBooks.removeAll { $0 == book }
        }
        
        book.readingStatus = targetStatus
        var targetList = (targetStatus == .reading) ? readingBooks : finishedBooks

        if index >= targetList.count {
            targetList.append(book)
        } else {
            targetList.insert(book, at: index)
        }
        
        if targetStatus == .reading {
            readingBooks = targetList
        } else {
            finishedBooks = targetList
        }

        for (idx, item) in targetList.enumerated() {
            item.sortIndex = Int64(idx)
        }
        StorageService.shared.saveData()
    }
}
