//
//  ZoomableImageView.swift
//  DetailContestFeature
//
//  Created by ParkJunHyuk on 7/16/25.
//

import SwiftUI

import DesignSystem
import Shared

import ComposableArchitecture
import Kingfisher

struct ZoomableImageView: View {
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @Environment(\.dismiss) var dismiss
    
    let url: String?

    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let url = url {
                KFImage(URL(string: url)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                self.scale = lastScale * value
                            }
                            .onEnded { value in
                                self.lastScale = scale
                                if scale < 1.0 {
                                    withAnimation {
                                        scale = 1.0
                                        lastScale = 1.0
                                    }
                                }
                            }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
            }
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 5)
            }
            .padding()
            .opacity(scale > 1.0 ? 0 : 1.0)
            .animation(.easeInOut, value: scale)
        }
    }
}
