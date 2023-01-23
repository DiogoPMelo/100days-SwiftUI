//
//  AlignedView92.swift
//  LayoutAndGeometry
//
//  Created by Diogo Melo on 8/12/20.
//

import SwiftUI

struct AlignedView92: View {
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@twostraws")
                    .background(Color.red)
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                Image("desktop Fiona")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            
            VStack {
                Text("Full name:")
                    .background(Color.red)
                Text("Full name:")
                    .padding(50)
                    .background(Color.red)
                Text("PAUL HUDSON")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                    .font(.largeTitle)
                    .background(Color.red)
            }
        }
    }
}

extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct AlignedView92_Previews: PreviewProvider {
    static var previews: some View {
        AlignedView92()
}
}
