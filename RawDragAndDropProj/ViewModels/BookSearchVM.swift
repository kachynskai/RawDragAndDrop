//
//  BookSearchVM.swift
//  RawDragAndDropProj
//
//  Created by Iryna on 26.11.2025.
//

import Foundation
import Combine

final class BookSearchVM: ObservableObject {
    @Published var searchText: String = ""
    @Published var books: [GoogleBookItem] = []
    @Published var isLoading: Bool = false
    
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        books = []
        Task {
            do {
                let fetchedBooks = try await BooksAPIService.shared.searchBooks(query: searchText)
                self.books = fetchedBooks
                print("Success! Found \(fetchedBooks.count) books.")
            } catch {
                print("Error in VM: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
}
