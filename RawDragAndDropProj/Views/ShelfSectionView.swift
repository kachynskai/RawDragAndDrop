//
//  ShelfSectionView.swift
//  RawDragAndDropProj
//
import SwiftUI
internal import UniformTypeIdentifiers

struct ShelfSectionView: View {
    let title: String
    let books: [Book]
    let color: Color
    
    let status: BookStatus
    @ObservedObject var viewModel: ShelfVM
    @Binding var draggedBook: Book?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                Spacer()
                Text("\(books.count)")
                    .font(.caption).bold()
                    .padding(6)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding()
            .background(Color.black.opacity(0.2))
            Divider()
            if books.isEmpty {
                Spacer()
                Text("Тут поки пусто")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .onDrop(of: [.text], isTargeted: nil) { _ in
                        if let draggedBook = draggedBook {
                            withAnimation {
                                viewModel.moveBookBetweenLists(book: draggedBook, to: 0, targetStatus: status)
                            }
                            return true
                        }
                        return false
                    }
                Spacer()
            } else {
                VStack(spacing: 0) {
                    ForEach(books) { book in
                        VStack(spacing: 0) {
                            NavigationLink(destination: BookDetailView(book: book)) {
                                ShelfRow(book: book)
                            }
                            .buttonStyle(.plain)
                            .onDrag {
                                self.draggedBook = book
                                return NSItemProvider(object: (book.title ?? "") as NSString)
                            }
                            .onDrop(of: [.text], delegate: BookDropDelegate(
                                item: book,
                                listType: status,
                                viewModel: viewModel,
                                curDraggedBook: $draggedBook
                            ))
                            if book != books.last {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct ShelfRow: View {
    @ObservedObject var book: Book
    
    var body: some View {
        HStack {
            Text(book.title ?? "Без назви")
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(.primary)
            
            Spacer()
            
            if book.readingStatus == .reading {
                Text(book.progressString)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.leading, 4)
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}
