//
//  BookRandomExcerpts.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct BookRandomExcerpts: View {
    @EnvironmentObject var bookStore: BookStore
    
    private var numberOfExcerpts = 5
    
    @State private var randomExcerpts: [Excerpt] = []
    
    var body: some View {
        List {
            Section(header: header) {
                ForEach(randomExcerpts) { excerpt in
                    ExcerptView(excerpt: excerpt)
                }
            }
        }
        .onAppear {
            randomExcerpts = bookStore.getRandomExcerpts(count: numberOfExcerpts)
        }
    }
    
    private var header: some View {
        HStack {
            Text("Random Excerpts")
            Button {
                randomExcerpts = bookStore.getRandomExcerpts(count: numberOfExcerpts)
            } label : {
                Label("Search", systemImage: "shuffle")
                    .labelStyle(.iconOnly)
            }
        }
    }
}

struct BookRandomExcerpts_Previews: PreviewProvider {
    static var previews: some View {
        BookRandomExcerpts()
            .environmentObject(BookStore())
    }
}
