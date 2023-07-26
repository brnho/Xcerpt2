//
//  Extensions.swift
//  Xcerpt
//
//  Created by Brian Ho on 5/27/23.
//

import Foundation
import SwiftUI

// code from https://lukeroberts.co/blog/fetch-data-api/
extension URLSession {
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error {
                completion(.failure(error))
            }
            
            if let data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}

// code from https://stackoverflow.com/questions/62632213/swift-use-hsl-color-space-instead-of-standard-hsb-hsv
extension Color {
    init(hue: Double, saturation: Double, lightness: Double, opacity: Double) {
        //From HSL TO HSB ---------
        var newSaturation: Double = 0.0
        
        let brightness = lightness + saturation * min(lightness, 1-lightness)
        
        if brightness == 0 { newSaturation = 0.0 }
        else {
            newSaturation = 2 * (1 - lightness / brightness)
        }
        //---------
        self.init(hue: hue, saturation: newSaturation, brightness: brightness, opacity: opacity)
    }
}

// code from https://stackoverflow.com/questions/49614659/generate-list-of-unique-random-numbers-in-swift-from-range
extension Int {
    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set).shuffled()
    }

}

struct RGBA: Codable, Equatable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
}

extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBA {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension Book {
    var uiColor1: Color {
        get { Color(rgba: color1) }
        set { color1 = RGBA(color: newValue) }
    }
    var uiColor2: Color {
        get { Color(rgba: color2) }
        set { color2 = RGBA(color: newValue) }
    }
}

// Code from https://designcode.io/swiftui-handbook-hide-keyboard
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
