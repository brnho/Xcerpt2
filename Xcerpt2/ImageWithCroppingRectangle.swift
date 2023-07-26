//
//  ImageWithCroppingRectangle.swift
//  Xcerpt
//
//  Created by Brian Ho on 7/20/23.
//

import SwiftUI

struct ImageWithCroppingRectangle: View {
    @State var rectangleWidth = 0.0
    @State var rectangleHeight = 0.0
    @State var rectangleX = 0.0
    @State var rectangleY = 0.0
    @State var isGestureActive = false
    
    @State var displayCroppedImage = false
    @State var croppedImage: UIImage?
    @State var imageHeight: CGFloat = 0
    @State var imageWidth: CGFloat = 0
    
    var setImageToNil: () -> Void
    var image: UIImage
    
    var body: some View {
        ZStack {
            if displayCroppedImage, let croppedImage {
                VStack {
                    Spacer()
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                Button(action: {
                    displayCroppedImage = false
                }) {
                    Text("revert")
                }
            }
            else {
                VStack {
                    Spacer()
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .overlay(GeometryReader { geometry in
                                instructionText
                                DraggableRectangle2(
                                    rectangleWidth: $rectangleWidth,
                                    rectangleHeight: $rectangleHeight,
                                    rectangleX: $rectangleX,
                                    rectangleY: $rectangleY,
                                    geometry: geometry,
                                    isGestureActive: $isGestureActive
                                )
                                .onAppear {
                                    imageHeight = geometry.size.height
                                    imageWidth = geometry.size.width
                                }
                            })
                        extractButton
                    }
                    Spacer()
                }
            }
        }
    }
    
    var dismissBar: some View {
        Text("Scanner")
    }
    
    var instructionText: some View {
        HStack {
            Spacer()
            (Text("Resize and drag the highlighter box to cover the text you wish to extract, then tap the ") + Text(Image(systemName: "doc.viewfinder")) + Text(" button"))
                .font(Font.system(size: 14))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                .background(.black.opacity(0.4))
                .cornerRadius(10)
                .frame(maxWidth: 0.9 * imageWidth)
                .offset(x: 0, y: 50)
                .opacity(isGestureActive ? 0 : 1)
                .animation(.easeInOut, value: isGestureActive)
            Spacer()
        }
    }
    
    var extractButton: some View {
        ZStack {
            HStack {
                Button(action: {
                    setImageToNil()
                }) {
                    Label("Retry", systemImage: "arrow.turn.up.left")
                        .foregroundColor(Color.gray)
                        .padding(10)
                }
                .background(Color.white)
                .cornerRadius(25)
                .offset(x: 10)
                Spacer()
            }
            Button(action: {
                cropImage()
            }) {
                Label("Bookmark", systemImage: "doc.viewfinder")
                    .labelStyle(.iconOnly)
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            //.offset(x: 0, y: imageHeight / 2 * 0.75)
        }
        .offset(x: 0, y: imageHeight / 2 * 0.75)
    }
    
    func cropImage() {
        let cgImage = image.cgImage
        guard cgImage != nil else { return }
        let scaleFactor = CGFloat(cgImage!.width) / imageHeight
        let croptRect = CGRect(x: rectangleY * scaleFactor, y: (imageWidth - rectangleX - rectangleWidth) * scaleFactor, width: rectangleHeight * scaleFactor, height: rectangleWidth * scaleFactor)
        let croppedCgImage = cgImage!.cropping(to: croptRect)
        guard croppedCgImage != nil else { return }
        croppedImage = UIImage(cgImage: croppedCgImage!, scale: image.imageRendererFormat.scale,
                               orientation: image.imageOrientation)
        displayCroppedImage = true
    }
}


struct ImageWithCroppingRectangle_Previews: PreviewProvider {
    struct Preview: View {
        @State var image: UIImage = UIImage(imageLiteralResourceName: "fantasy")
        var body: some View {
            ImageWithCroppingRectangle(setImageToNil: {}, image: image)
        }
    }
    static var previews: some View {
        Preview()
    }
}

