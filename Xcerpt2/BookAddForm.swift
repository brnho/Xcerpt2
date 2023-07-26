//
//  BooksSearchForm.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/27/23.
//

import SwiftUI

struct BookAddForm: View {
    @Environment(\.dismiss) var dismiss
    
    typealias GoogleBookWrapper = GoogleBooks.GoogleBookWrapper
    private let GOOGLE_API_KEY = "AIzaSyADRN5e9ZW61-sHZm0f-XKkQluTI4kvOI8"
    private let maxResults = 10
    
    @State private var searchText = ""
    @State private var isFetching = false
    @State private var googleBookWrappers: [GoogleBookWrapper] = []
    
    // Fix for progress view bug: https://stackoverflow.com/questions/75373975/progress-view-doesnt-show-on-second-load-when-trying-to-do-pagination-swiftui
    @State var progressViewId = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Search for books to add", text: $searchText)
                        searchButton
                    }
                }
                Section {
                    if isFetching {
                        loadingView
                    }
                    ForEach(googleBookWrappers) { wrapper in
                        if let index = googleBookWrappers.firstIndex(where: { $0.id == wrapper.id }) {
                            NavigationLink(value: wrapper.volumeInfo) {
                                GoogleBookRow(book: $googleBookWrappers[index].volumeInfo)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                NewBookEditForm(book: book, dismiss: dismiss)
            }
        }
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .id(progressViewId)
                .onAppear {
                    progressViewId += 1
                }
            Spacer()
        }
    }
    
    private var searchButton: some View {
        Button {
            if searchText.count > 0 {
                searchForBooks()
            }
        } label : {
            Label("Search", systemImage: "magnifyingglass")
                .labelStyle(.iconOnly)
        }
    }
    
    private func searchForBooks() {
        googleBookWrappers = []
        isFetching = true
        let baseUrl = URL(string: "https://www.googleapis.com/books/v1/volumes?")!
        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "key", value: GOOGLE_API_KEY),
            URLQueryItem(name: "maxResults", value: String(maxResults))
        ])
        
        URLSession.shared.fetchData(for: url) { (result: Result<GoogleBooks, Error>) in
            switch result {
            case .success(let googleBooks):
                googleBookWrappers = googleBooks.items
                isFetching = false
            case .failure(let error):
                isFetching = false
                // change this to an alert
                print(error)
            }
        }
    }
}

struct BookAddForm_Previews: PreviewProvider {
    static var previews: some View {
        BookAddForm()
    }
}
