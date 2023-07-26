//
//  DraggableRectangle.swift
//  Camera Test
//
//  Created by Brian Ho on 6/9/23.
//

import SwiftUI

struct DraggableRectangle: View {
    // communicate rectangle dimensions to parent struct
    @Binding var rectangleWidth: Double
    @Binding var rectangleHeight: Double
    @Binding var rectangleX: Double
    @Binding var rectangleY: Double
    let geometry: GeometryProxy
    
    var originalWidth = 200.0
    var originalHeight = 200.0
    let borderWidth = 7.0
    let circleRadius = 10.0
    let minWidth = 20.0
    let minHeight = 20.0
    let rectColor = Color.yellow.opacity(0.2)
    let borderColor = Color.yellow
    
    var width: Double {
        max(originalWidth + horizontalPan + gestureHorizontalPan, minWidth)
    }
    var height: Double {
        max(originalHeight + verticalPan + gestureVerticalPan, minHeight)
    }
    var x: Double {
        geometry.size.width/2 - width/2 + centerTranslation.width + gestureCenterTranslation.width
    }
    
    var y: Double {
        geometry.size.height/2 - height/2 + centerTranslation.height + gestureCenterTranslation.height
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
                .gesture(getHorizontalPanGesture(for: .right))
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
                .gesture(getHorizontalPanGesture(for: .left))
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
                .gesture(getVerticalPanGesture(for: .top))
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
                .gesture(getVerticalPanGesture(for: .bottom))
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
                .gesture(getVerticalPanGesture(for: .top).simultaneously(with: getHorizontalPanGesture(for: .left)))
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
                .gesture(getVerticalPanGesture(for: .top).simultaneously(with: getHorizontalPanGesture(for: .right)))
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
                .gesture(getVerticalPanGesture(for: .bottom).simultaneously(with: getHorizontalPanGesture(for: .right)))
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
                .gesture(getVerticalPanGesture(for: .bottom).simultaneously(with: getHorizontalPanGesture(for: .left)))
        }
    }
    
    @State private var horizontalPan = 0.0
    @State private var verticalPan = 0.0
    @State private var centerTranslation: CGOffset = .zero
    @GestureState private var gestureHorizontalPan = 0.0
    @GestureState private var gestureVerticalPan = 0.0
    @GestureState private var gestureCenterTranslation: CGOffset = .zero
    
    enum Side {
        case left
        case right
        case top
        case bottom
    }
    
    func getHorizontalPanGesture(for side: Side) -> some Gesture {
        return DragGesture()
            .updating($gestureHorizontalPan) { inMotionDragGestureValue, gestureHorizontalPan, _ in
                gestureHorizontalPan = side == .right ?  inMotionDragGestureValue.translation.width * 2 : inMotionDragGestureValue.translation.width * -2
            }
            .onEnded { endingDragGestureValue in
                horizontalPan += side == .right ?  endingDragGestureValue.translation.width * 2 : endingDragGestureValue.translation.width * -2
                if originalWidth + horizontalPan < minWidth {
                    horizontalPan = minWidth - originalWidth
                }
                updateDimensions()
            }
    }
    
    func getVerticalPanGesture(for side: Side) -> some Gesture {
        return DragGesture()
            .updating($gestureVerticalPan) { inMotionDragGestureValue, gestureVerticalPan, _ in
                gestureVerticalPan = side == .bottom ?  inMotionDragGestureValue.translation.height * 2 : inMotionDragGestureValue.translation.height * -2
            }
            .onEnded { endingDragGestureValue in
                verticalPan += side == .bottom ?  endingDragGestureValue.translation.height * 2 : endingDragGestureValue.translation.height * -2
                if originalHeight + verticalPan < minHeight {
                    verticalPan = minHeight - originalHeight
                }
                updateDimensions()
            }
    }
    
    private var translationGesture: some Gesture {
        DragGesture()
            .updating($gestureCenterTranslation) { inMotionDragGestureValue, gestureCenterTranslation, _ in
                gestureCenterTranslation.width = inMotionDragGestureValue.translation.width
                gestureCenterTranslation.height = inMotionDragGestureValue.translation.height
            }
            .onEnded { endingDragGestureValue in
                centerTranslation += endingDragGestureValue.translation
                updateDimensions()
            }
    }
}

typealias CGOffset = CGSize

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y-size.height/2), size: size)
    }
}

extension CGOffset {
    static func +(lhs: CGOffset, rhs: CGOffset) -> CGOffset {
        CGOffset(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func +=(lhs: inout CGOffset, rhs: CGOffset) {
        lhs = lhs + rhs
    }
}

struct DraggableRectangle_Previews: PreviewProvider {
    struct Preview: View {
        @State var rectangleWidth = 0.0
        @State var rectangleHeight = 0.0
        @State var rectangleX = 0.0
        @State var rectangleY = 0.0
        var body: some View {
            GeometryReader { geometry in
                DraggableRectangle(rectangleWidth: $rectangleWidth,
                                   rectangleHeight: $rectangleHeight,
                                   rectangleX: $rectangleX,
                                   rectangleY: $rectangleY,
                                   geometry: geometry)
            }
        }
    }
    static var previews: some View {
        Preview()
    }
}
