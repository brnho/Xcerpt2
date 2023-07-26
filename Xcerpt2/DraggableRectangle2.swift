//
//  DraggableRectangle.swift
//  Camera Test
//
//  Created by Brian Ho on 6/9/23.
//

import SwiftUI

struct DraggableRectangle2: View {
    // communicate rectangle dimensions to parent struct
    @Binding var rectangleWidth: Double
    @Binding var rectangleHeight: Double
    @Binding var rectangleX: Double
    @Binding var rectangleY: Double
    let geometry: GeometryProxy
    @Binding var isGestureActive: Bool
    
    var originalWidth = 300.0
    var originalHeight = 200.0
    let borderWidth = 3.0
    let circleRadius = 12.0
    let minWidth = 20.0
    let minHeight = 20.0
    let rectColor = Color.yellow.opacity(0.2)
    let borderColor = Color.yellow
    
    var width: Double {
        originalWidth + leftPan + rightPan + gestureLeftPan + gestureRightPan
    }
    var height: Double {
        max(originalHeight + topPan + downPan + gestureTopPan + gestureDownPan, minHeight)
    }
    var x: Double {
        geometry.size.width/2 - originalWidth/2 - leftPan - gestureLeftPan + centerTranslation.width + gestureCenterTranslation.width
    }
    
    var y: Double {
        geometry.size.height/2 - originalHeight/2 - topPan - gestureTopPan + centerTranslation.height + gestureCenterTranslation.height
    }
    
    func updateDimensions() {
        rectangleWidth = width
        rectangleHeight = height
        rectangleX = x
        rectangleY = y
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .path(in: CGRect(
                    x: x,
                    y: y,
                    width: width,
                    height: height
                ))
                .fill(rectColor)
                .gesture(translationGesture)
                .overlay(
                    Group {
                        rightBorder()
                        leftBorder()
                        topBorder()
                        bottomBorder()
                        topLeftCircle()
                        topRightCircle()
                        bottomRightCircle()
                        bottomLeftCircle()
                    }
                )
        }
        .onAppear {
            updateDimensions()
        }
    }
    
    private func rightBorder() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(
                    x: x + width,
                    y: y,
                    width: borderWidth,
                    height: height
                ))
                .fill(borderColor)
        }
    }
    
    private func leftBorder() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(
                    x: x - borderWidth,
                    y: y,
                    width: borderWidth,
                    height: height
                ))
                .fill(borderColor)
        }
    }
    
    private func topBorder() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(
                    x: x - borderWidth,
                    y: y - borderWidth,
                    width: width + 2 * borderWidth,
                    height: borderWidth
                ))
                .fill(borderColor)
        }
    }
    
    private func bottomBorder() -> some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(
                    x: x - borderWidth,
                    y: y + height,
                    width: width + 2 * borderWidth,
                    height: borderWidth
                ))
                .fill(borderColor)
        }
    }
    
    private func topLeftCircle() -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 100)
                .path(in: CGRect(
                    x: x - borderWidth/2 - circleRadius,
                    y: y - borderWidth/2 - circleRadius,
                    width: circleRadius * 2,
                    height: circleRadius * 2
                ))
                .fill(borderColor)
                .gesture(getTopPanGesture().simultaneously(with: getLeftPanGesture()))
        }
    }
    
    private func topRightCircle() -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 100)
                .path(in: CGRect(
                    x: x + width + borderWidth/2 - circleRadius,
                    y: y - borderWidth/2 - circleRadius,
                    width: circleRadius * 2,
                    height: circleRadius * 2
                ))
                .fill(borderColor)
                .gesture(getTopPanGesture().simultaneously(with: getRightPanGesture()))
        }
    }
    
    private func bottomRightCircle() -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 100)
                .path(in: CGRect(
                    x: x + width + borderWidth/2 - circleRadius,
                    y: y + height + borderWidth/2 - circleRadius,
                    width: circleRadius * 2,
                    height: circleRadius * 2
                ))
                .fill(borderColor)
                .gesture(getDownPanGesture().simultaneously(with: getRightPanGesture()))
        }
    }
    
    private func bottomLeftCircle() -> some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 100)
                .path(in: CGRect(
                    x: x - borderWidth/2 - circleRadius,
                    y: y + height + borderWidth/2 - circleRadius,
                    width: circleRadius * 2,
                    height: circleRadius * 2
                ))
                .fill(borderColor)
                .gesture(getDownPanGesture().simultaneously(with: getLeftPanGesture()))
        }
    }
    
    @State private var leftPan = 0.0
    @State private var rightPan = 0.0
    @State private var topPan = 0.0
    @State private var downPan = 0.0
    @State private var centerTranslation: CGOffset = .zero
    @GestureState private var gestureLeftPan = 0.0
    @GestureState private var gestureRightPan = 0.0
    @GestureState private var gestureTopPan = 0.0
    @GestureState private var gestureDownPan = 0.0
    @GestureState private var gestureCenterTranslation: CGOffset = .zero
    
    enum Side {
        case left
        case right
        case top
        case bottom
    }
    
    func getLeftPanGesture() -> some Gesture {
        return DragGesture()
            .updating($gestureLeftPan) { inMotionDragGestureValue, gestureLeftPan, _ in
                gestureLeftPan = inMotionDragGestureValue.translation.width * -1
                if originalWidth + leftPan + rightPan + gestureLeftPan + gestureRightPan < minWidth {
                    gestureLeftPan = minWidth - originalWidth - leftPan - rightPan - gestureRightPan
                }
            }
            .onChanged { _ in
                isGestureActive = true
            }
            .onEnded { endingDragGestureValue in
                leftPan += endingDragGestureValue.translation.width * -1
                if originalWidth + leftPan + rightPan + gestureLeftPan + gestureRightPan < minWidth {
                    leftPan = minWidth - originalWidth - gestureLeftPan - rightPan - gestureRightPan
                }
                updateDimensions()
                isGestureActive = false
            }
    }
    
    func getRightPanGesture() -> some Gesture {
        return DragGesture()
            .updating($gestureRightPan) { inMotionDragGestureValue, gestureRightPan, _ in
                gestureRightPan = inMotionDragGestureValue.translation.width
                if originalWidth + leftPan + rightPan + gestureLeftPan + gestureRightPan < minWidth {
                    gestureRightPan = minWidth - originalWidth - leftPan - rightPan - gestureLeftPan
                }
            }
            .onChanged { _ in
                isGestureActive = true
            }
            .onEnded { endingDragGestureValue in
                rightPan += endingDragGestureValue.translation.width
                if originalWidth + leftPan + rightPan + gestureLeftPan + gestureRightPan < minWidth {
                    rightPan = minWidth - originalWidth - leftPan - gestureRightPan - gestureLeftPan
                }
                updateDimensions()
                isGestureActive = false
            }
    }
    
    func getTopPanGesture() -> some Gesture {
        return DragGesture()
            .updating($gestureTopPan) { inMotionDragGestureValue, gestureTopPan, _ in
                gestureTopPan = inMotionDragGestureValue.translation.height * -1
                if originalHeight + topPan + downPan + gestureTopPan + gestureDownPan < minHeight {
                    gestureTopPan = minHeight - (originalHeight + topPan + downPan + gestureDownPan)
                }
            }
            .onChanged { _ in
                isGestureActive = true
            }
            .onEnded { endingDragGestureValue in
                topPan += endingDragGestureValue.translation.height * -1
                if originalHeight + topPan + downPan + gestureTopPan + gestureDownPan < minHeight {
                    topPan = minHeight - (originalHeight + downPan + gestureTopPan + gestureDownPan)
                }
                updateDimensions()
                isGestureActive = false
            }
    }
    
    func getDownPanGesture() -> some Gesture {
        return DragGesture()
            .updating($gestureDownPan) { inMotionDragGestureValue, gestureDownPan, _ in
                gestureDownPan = inMotionDragGestureValue.translation.height
                if originalHeight + topPan + downPan + gestureTopPan + gestureDownPan < minHeight {
                    gestureDownPan = minHeight - (originalHeight + topPan + downPan + gestureTopPan)
                }
            }
            .onChanged { _ in
                isGestureActive = true
            }
            .onEnded { endingDragGestureValue in
                downPan += endingDragGestureValue.translation.height
                if originalHeight + topPan + downPan + gestureTopPan + gestureDownPan < minHeight {
                    downPan = minHeight - (originalHeight + topPan + gestureTopPan + gestureDownPan)
                }
                updateDimensions()
                isGestureActive = false
            }
    }
    
    private var translationGesture: some Gesture {
        DragGesture()
            .updating($gestureCenterTranslation) { inMotionDragGestureValue, gestureCenterTranslation, _ in
                gestureCenterTranslation.width = inMotionDragGestureValue.translation.width
                gestureCenterTranslation.height = inMotionDragGestureValue.translation.height
            }
            .onChanged { _ in
                isGestureActive = true
            }
            .onEnded { endingDragGestureValue in
                centerTranslation += endingDragGestureValue.translation
                updateDimensions()
                isGestureActive = false
            }
    }
}

struct DraggableRectangle2_Previews: PreviewProvider {
    struct Preview: View {
        @State var rectangleWidth = 0.0
        @State var rectangleHeight = 0.0
        @State var rectangleX = 0.0
        @State var rectangleY = 0.0
        @State var isGestureActive = false
        var body: some View {
            GeometryReader { geometry in
                DraggableRectangle2(
                    rectangleWidth: $rectangleWidth,
                    rectangleHeight: $rectangleHeight,
                    rectangleX: $rectangleX,
                    rectangleY: $rectangleY,
                    geometry: geometry,
                    isGestureActive: $isGestureActive
                )
            }
        }
    }
    static var previews: some View {
        Preview()
    }
}

