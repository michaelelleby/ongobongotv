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
    var videoURL: URL {
        get {
            return _videoURL!
        }
    }
    var imageURL: URL {
        get {
            return _imageURL!
        }
    }

    private var _videoURL: URL?
    private var _imageURL: URL?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        urn <- map["Urn"]
        title <- map["Title"]
        
        _videoURL <- (map["PrimaryAsset.Uri"], URLTransform(shouldEncodeURLString: true))
        _imageURL <- (map["PrimaryImageUri"], URLTransform(shouldEncodeURLString: true))
    }
}
