//
//  BindingExcerptView.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/30/23.
//

import SwiftUI

struct BindingExcerptView: View, Animatable {
    @Environment(\.colorScheme) var colorScheme
    @Binding var excerpt: Excerpt
    
    init(excerpt: Binding<Excerpt>) {
        self._excerpt = excerpt
        rotation = excerpt.isFaceUp.wrappedValue ? 0 : 180
        brightnessFront = excerpt.isFaceUp.wrappedValue ? 0 : -0.3
        brightnessBack = excerpt.isFaceUp.wrappedValue ? -0.3 : 0
    }
    
    private var rotation: Double
    private var brightnessFront: Double
    private var brightnessBack: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var body: some View {
        ZStack {
            excerptFront
                .opacity(isFaceUp ? 1 : 0)
                .onTapGesture {
                    excerpt.isFaceUp.toggle()
                }
            excerptBack
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(excerpt.isFaceUp ? 0 : 180), axis: (0,1,0))
    }
    
    private var excerptFront: some View {
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
        .background(colorScheme == .light ? Color(uiColor: UIColor.systemBackground) : Color(uiColor: UIColor.secondarySystemBackground))
        .brightness(colorScheme == .light ? brightnessFront : -1 * brightnessFront)
    }
    
    private var excerptBack: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Note")
                    .foregroundColor(.secondary)
                flipButton
            }
            .padding(5)
            HStack(spacing: 0) {
                TextEditor(text: $message)
                    //.fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(5)
        .background(colorScheme == .light ? Color(uiColor: UIColor.systemBackground) : Color(uiColor: UIColor.secondarySystemBackground))
        .brightness(colorScheme == .light ? brightnessBack : -1 * brightnessBack)
        .rotation3DEffect(.degrees(180), axis: (0,1,0))
    }
    
    @State private var message: String = "hi"
    
    private var bookmarkButton: some View {
        Button {
            excerpt.isBookmarked.toggle()
        } label: {
            Label("Bookmark", systemImage: excerpt.isBookmarked ? "bookmark.fill" : "bookmark")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    private var flipButton: some View {
        Button {
            excerpt.isFaceUp.toggle()
        } label: {
            Label("Flip", systemImage: "return.right")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct BindingExcerptView_Previews: PreviewProvider {
    struct Preview: View {
        @ObservedObject var bookStore = BookStore()
        var body: some View {
            BindingExcerptView(excerpt: $bookStore.books[0].excerpts[0])
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
