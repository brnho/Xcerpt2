//
//  ExcerptView.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct ExcerptView: View {
    var excerpt: Excerpt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(excerpt.text)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                if let chapter = excerpt.chapter {
                    Text("Chapter \(chapter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if let page = excerpt.page {
                    Text("Page \(page)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                bookmarkButton
            }
        }
        .padding(5)
    }
    
    private var bookmarkButton: some View {
        Button {
            
        } label: {
            Label("Bookmark", systemImage: excerpt.isBookmarked ? "bookmark.fill" : "bookmark")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ExcerptView_Previews: PreviewProvider {
    static var previews: some View {
        ExcerptView(excerpt: BookStore().books[0].excerpts[0])
    }
}
