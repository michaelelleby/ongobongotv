//
//  ProgramCard.swift
//  DRTVApp
//
//  Created by Michael on 29/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

import Foundation
import ObjectMapper

class ProgramCard : Mappable {
    var urn: String?
    var title: String?
    var videoURL: URL? {
        get {
            return _videoURL
        }
    }
    var imageURL: URL? {
        get {
            return _imageURL
        }
    }

    private var _primaryAssetUri: String?
    private var _primaryAssetKind: AssetKind?
    private var _assets: [Asset]
    private var _videoURL: URL?
    private var _imageURL: URL?
    
    required init?(map: Map) {
        _assets = []
    }
    
    func mapping(map: Map) {
        urn <- map["Urn"]
        title <- map["Title"]
        
        _primaryAssetUri <- map["PrimaryAssetUri"]
        _primaryAssetKind <- (map["PrimaryAssetKind"],EnumTransform<AssetKind>())
        _assets <- map["Assets"]

        let videoAssets = _assets.filter {$0.kind == .VideoResource }
        if videoAssets.count > 0 {
            _videoURL = videoAssets[0].uri
        }
        let imageAssets = _assets.filter {$0.kind == .Image }
        if imageAssets.count > 0 {
            _imageURL = imageAssets[0].uri
        }
    }
}

enum AssetKind : String {
    case VideoResource = "VideoResource"
    case Image = "Image"
}

class Asset : Mappable {
    var kind: AssetKind?
    var uri: URL? {
        get {
            if _uri == nil {
                return nil
            }
            return URL(string: _uri!)!
        }
    }
    var trashed: Bool?
    
    private var _uri: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        kind <- map["Kind"]
        trashed <- map["Trashed"]

        _uri <- map["Uri"]
    }
}
