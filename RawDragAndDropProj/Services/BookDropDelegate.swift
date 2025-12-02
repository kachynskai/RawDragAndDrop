//
//  BookDropDelegate.swift
//  RawDragAndDropProj
//
import SwiftUI

struct BookDropDelegate: DropDelegate {
    let item: Book
    let listType: BookStatus
    let viewModel: ShelfVM
    @Binding var curDraggedBook: Book?
    
    func performDrop(info: DropInfo) -> Bool {
        self.curDraggedBook = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedBook = curDraggedBook
        else { return }
        
        if draggedBook.readingStatus == listType {
            if draggedBook != item {
                withAnimation {
                    viewModel.reorderBooks(from: draggedBook, to: item, in: listType)
                }
            }
        } else {
            let targetList = (listType == .reading) ? viewModel.readingBooks : viewModel.finishedBooks
            if let targetIndex = targetList.firstIndex(of: item) {
                withAnimation(.default) {
                    viewModel.moveBookBetweenLists(book: draggedBook, to: targetIndex, targetStatus: listType)
                }
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
