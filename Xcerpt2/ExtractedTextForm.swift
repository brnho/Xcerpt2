//
//  ExtractedTextForm.swift
//  Xcerpt
//
//  Created by Brian Ho on 6/7/23.
//

import SwiftUI
import Vision

struct ExtractedTextForm: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String?
    @State private var chapter: String = ""
    @State private var page: String = ""
    @Binding var book: Book
    private var image: UIImage
    
    init(image: UIImage, book: Binding<Book>) {
        self.image = image
        self._book = book
    }
    
    var body: some View {
        VStack {
            if let unwrappedText = text {
                Form {
                    Section(header: Text("Captured Text")) {
                        let binding = Binding { unwrappedText } set: { text = $0 }
                        TextEditor(text: binding)
                            .frame(minHeight: 500)
                    }
                    Section {
                        HStack {
                            Text("Chapter").bold()
                            TextField("Chapter", text: $chapter)
                                .keyboardType(.numberPad)
                        }
                        HStack {
                            Text("Page").bold()
                            TextField("Page", text: $page)
                                .keyboardType(.numberPad)
                        }
                    }
                    Section {
                        confirmButton
                    }
                    Section {
                        cancelButton
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            recognizeText(in: image)
        }
    }
    
    private var confirmButton: some View {
        Button("Confirm") {
            if let text {
                let ch = chapter != "" ? Int(chapter) : nil
                let pg = page != "" ? Int(page) : nil
                let newExcerpt = Excerpt(text: text, chapter: ch, page: pg)
                book.excerpts.append(newExcerpt)
            }
            dismiss()
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .foregroundColor(.red)
    }
    
    private func recognizeText(in image: UIImage) {
        // Get the CGImage on which to perform requests.
        guard let cgImage = image.cgImage else { return }
        
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.revision = VNRecognizeTextRequestRevision3
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        //getBoundingRects(for: observations)
        
        text = recognizedStrings.joined(separator: " ")
        print(recognizedStrings.joined(separator: " "))
    }
}

/*
struct ExtractedTextForm_Previews: PreviewProvider {
    static var previews: some View {
        ExtractedTextForm()
    }
}
*/
