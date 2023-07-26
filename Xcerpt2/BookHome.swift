//
//  ContentView.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/27/23.
//

import SwiftUI

struct BookHome: View {
    @EnvironmentObject var bookStore: BookStore
    @EnvironmentObject var userPreferences: UserPreferences
    @State private var searchText = ""
    @State private var showFilterForm = false
    @State private var showAddForm = false
    @State private var showOnlyFavorites = false
    @State private var indexOfBookToEdit: Int?
    @State private var showBookEditForm = false
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack() {
            List {
                books()
            }
            .navigationDestination(for: Book.self) { book in
                if let index = $bookStore.books.firstIndex(where: { $0.id == book.id }) {
                    BookExcerpt(book: $bookStore.books[index])
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .navigationTitle("Xcerpt")
            .toolbar {
                darkModeButton
                filterButton
                addButton
            }
            .sheet(isPresented: $showFilterForm) {
                BookFilterForm(sortOrder: $bookStore.sortOrder, showOnlyFavorites: $showOnlyFavorites)
            }
            .sheet(isPresented: $showAddForm) {
                BookAddForm()
            }
            .sheet(isPresented: $showBookEditForm) {
                BookEditFormWrapper(indexOfBookToEdit: $indexOfBookToEdit)
            }
            //AnimationHack(book: $bookStore.books[0])
        }
        .searchable(text: $searchText, prompt: "Search for a book")
    }
    
    // Weird hack: without this struct in the above list, the animation for the excerpts does not work properly
    struct AnimationHack: View {
        @Binding var book: Book
        var body: some View {
            EmptyView()
        }
    }
    
    // this is a workaround to avoid this error: https://stackoverflow.com/questions/64551580/swiftui-sheet-doesnt-access-the-latest-value-of-state-variables-on-first-appear
    struct BookEditFormWrapper: View {
        @EnvironmentObject var bookStore: BookStore
        @Binding var indexOfBookToEdit: Int?
        
        var body: some View {
            if let indexOfBookToEdit {
                BookEditForm(book: $bookStore.books[indexOfBookToEdit])
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search for Books", text: $searchText)
            Button {
                
            } label: {
                Label("Search", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
            }
        }
    }
    
    private var addButton: some View {
        Button {
            showAddForm = true
        } label: {
            Label("Search", systemImage: "plus")
                .labelStyle(.iconOnly)
        }
    }
    
    private var filterButton: some View {
        Button {
            showFilterForm = true
        } label: {
            Label("Search", systemImage: "line.3.horizontal.decrease.circle")
                .labelStyle(.iconOnly)
        }
    }
    
    private var darkModeButton: some View {
        Button {
            withAnimation {
                userPreferences.darkMode.toggle()
            }
        } label: {
            Label("Dark Mode", systemImage: userPreferences.darkMode ? "sun.max.fill" : "moon.stars.fill")
                .labelStyle(.iconOnly)
                .foregroundColor(userPreferences.darkMode ? .yellow : Color(hue: 0.0, saturation: 0.0, brightness: 0.5))
                .rotationEffect(.degrees(userPreferences.darkMode ? 0 : 360))
        }
    }
    
    private func books() -> some View {
        let filteredBooks: [Book] = filterBooks()
        return ForEach(filteredBooks) { book in
            if let index = $bookStore.books.firstIndex(where: { $0.id == book.id }) {
                NavigationLink(value: book) {
                    HStack {
                        BookRow(book: $bookStore.books[index])
                        Spacer()
                        if book.isFavorited {
                            Image(systemName: "star.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                .contextMenu {
                    contextMenu(index: index)
                }
            }
        }
    }
    
    private func contextMenu(index: Int) -> some View {
        Group {
            Button {
                indexOfBookToEdit = index
                showBookEditForm = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button(role: .destructive) {
                
            } label: {
                Label("Delete", systemImage: "minus.circle")
            }
        }
    }
    
    private func filterBooks() -> [Book] {
        var filteredBooks: [Book] = []
        if searchText.isEmpty {
            filteredBooks = bookStore.books
        } else {
            filteredBooks = bookStore.books.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.authors.joined(separator: "").localizedCaseInsensitiveContains(searchText)}
        }
        if showOnlyFavorites {
            filteredBooks = filteredBooks.filter({ $0.isFavorited })
        }
        return filteredBooks
    }
}

struct BookHome_Previews: PreviewProvider {
    static var previews: some View {
        BookHome()
            .environmentObject(BookStore())
            .environmentObject(UserPreferences())
    }
}
