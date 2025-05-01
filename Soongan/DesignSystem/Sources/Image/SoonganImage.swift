//
//  SoonganImage.swift
//  Studing
//
//  Created by ParkJunHyuk on 5/1/25.
//

import SwiftUI
import Resource

public extension Image {
    static var reportCard: Image {
        return ResourceAsset.Image.report.swiftUIImage
    }
    
    static var selectLike: Image {
        return ResourceAsset.Image.selectLike.swiftUIImage
    }
    
    static var notSelectLike: Image {
        return ResourceAsset.Image.notSelectLike.swiftUIImage
    }
    
    static var editPost: Image {
        return ResourceAsset.Image.editPost.swiftUIImage
    }
    
    static var deletePost: Image {
        return ResourceAsset.Image.deletePost.swiftUIImage
    }
}

// MARK: - TabBar Image

public extension Image {
    static var selectHomeIcon: Image {
        return ResourceAsset.Image.selectHome.swiftUIImage
    }
    
    static var notSelectHomeIcon: Image {
        return ResourceAsset.Image.notSelectHome.swiftUIImage
    }
    
    static var selectPictureIcon: Image {
        return ResourceAsset.Image.selectPicture.swiftUIImage
    }
    
    static var notSelectPictureIcon: Image {
        return ResourceAsset.Image.notSelectPicture.swiftUIImage
    }
    
    static var selectAwardIcon: Image {
        return ResourceAsset.Image.selectAward.swiftUIImage
    }
    
    static var notSelectAwardIcon: Image {
        return ResourceAsset.Image.notSelectAward.swiftUIImage
    }
    
    static var selectMypageIcon: Image {
        return ResourceAsset.Image.selectMypage.swiftUIImage
    }
    
    static var notSelectMypageIcon: Image {
        return ResourceAsset.Image.notSelectMypage.swiftUIImage
    }
}
