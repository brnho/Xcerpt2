//
//  Temp.swift
//  Xcerpt
//
//  Created by Brian Ho on 7/24/23.
//

import SwiftUI

struct Temp: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                
                ZStack {
                    HStack {
                        Button {
                            
                        } label: {
                            Label("Dismiss", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                        }
                        .offset(x: 10)
                        Spacer()
                    }
                    Text("Scanner")
                }
                .frame(width: geometry.size.width)
                .padding(.vertical, 10)
                .background(Color.red)
                
                Button(action: {
                    
                }) {
                    Label("Bookmark", systemImage: "arrow.turn.up.left")
                        .foregroundColor(Color.gray)
                        .padding(15)
                        
                        
                        //.clipShape(Circle())
                        //.labelStyle(.iconOnly)
                }
                .background(Color.white)
                .cornerRadius(25)
            }
        }
    }
}

struct Temp_Previews: PreviewProvider {
    static var previews: some View {
        Temp()
    }
}
