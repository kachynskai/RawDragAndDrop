//
//  BookSearchView.swift
//  RawDragAndDropProj
//
//  Created by Iryna on 26.11.2025.
//

import SwiftUI

struct BookSearchView: View {
    @StateObject private var seachVM = BookSearchVM()
    var body: some View {
        VStack {
            HStack {
                TextField("Enter the book's title", text: $seachVM.searchText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        seachVM.performSearch()
                    }
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    seachVM.performSearch()
                })
                {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color(.white))
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
            }
            .padding()
            
            if seachVM.isLoading {
                ProgressView("Searching")
            } else if seachVM.books.isEmpty {
                Spacer()
                if !seachVM.searchText.isEmpty {
                    Text("No books found for '\(seachVM.searchText)'\n Please try again")
                        .foregroundColor(.secondary)
                } else {
                    Text("Please enter a book title to search")
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List(seachVM.books, id: \.id) { book in
                    VStack(alignment: .leading) {
                        Text(book.volumeInfo.title)
                            .font(.headline)
    
                        Text(book.volumeInfo.authorsList)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let pageCount = book.volumeInfo.pageCount {
                            Text("Сторінок: \(pageCount)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)
                
            }
            
        }
    }
}

#Preview {
    BookSearchView()
}
