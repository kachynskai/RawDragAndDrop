//
//  StorageService.swift
//  RawDragAndDropProj
//

internal import CoreData

final class StorageService {
    static let shared = StorageService()
    
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext { container.viewContext }
    
    private init() {
        self.container = PersistenceController.shared.container
    }
    
    func fetchAllBooks() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.sortIndex, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching books: \(error)")
            return []
        }
    }
    
    func fetchBooks(by status: BookStatus) -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        request.predicate = NSPredicate(format: "status == %@", status.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.sortIndex, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error with fetching books with status -- \(status): \(error)")
            return []
        }
    }
    
    func addBook(from googleBook: GoogleBookItem) {
        let newBook = Book(context: context)
        
        newBook.id = UUID()
        newBook.title = googleBook.volumeInfo.title
        newBook.desc = googleBook.volumeInfo.description ?? "No description"
        newBook.author = googleBook.volumeInfo.authorsList
        newBook.imageURL = googleBook.volumeInfo.imageURL
        newBook.pageCount = Int16(googleBook.volumeInfo.pageCount ?? 0)
        
        newBook.currentPage = 0
        newBook.readingStatus = .wantToRead
        
        let curMin = getCurMinIndex()
        newBook.sortIndex = curMin - 1
        
        saveData()
        
    }
    
    func updateStatus(for book: Book, newStatus: BookStatus) {
        switch (book.readingStatus, newStatus) {
        case (_, .finished):
            if book.pageCount > 0 {
                book.currentPage = book.pageCount
            }
        case (.finished, .reading):
            break
        case (_, .wantToRead):
            book.currentPage = 0
        default:
            break
        }
        book.readingStatus = newStatus
        saveData()
    }
    
    func updateProgress(book: Book, newPage: Int) {
        book.currentPage = Int16(newPage)
        
        if book.pageCount > 0 && newPage >= book.pageCount {
            updateStatus(for: book, newStatus: .finished)
        } else {
            if book.readingStatus == .wantToRead && newPage > 0 {
                updateStatus(for: book, newStatus: .reading)
            } else {
                saveData()
            }
        }
    }
    
    func deleteBook(_ book: Book) {
        context.delete(book)
        saveData()
    }
    
    private func getCurMinIndex() -> Int64 {
        let allBooks = fetchAllBooks()
        return (allBooks.first?.sortIndex ?? 0)
    }
    
    private func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error with saving in to database: \(error.localizedDescription)")
            }
        }
    }
    
}
