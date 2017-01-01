//
//  Manifest.swift
//  DRTVApp
//
//  Created by Michael on 01/01/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import ObjectMapper

struct Manifest : Mappable {
    var links: [ManifestLink]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        links <- map["Links"]
    }
}

struct ManifestLink : Mappable {
    var uri: URL?
    var encryptedUri: URL?
    var hardSubtitlesType: String?
    var format: ManifestFileFormat?
    var target: ManifestTarget?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        uri <- (map["Uri"], URLTransform(shouldEncodeURLString: true))
        encryptedUri <- (map["EncryptedUri"], URLTransform(shouldEncodeURLString: true))
        hardSubtitlesType <- map["HardSubtitlesType"]
        format <- (map["FileFormat"],EnumTransform<ManifestFileFormat>())
        target <- (map["Target"],EnumTransform<ManifestTarget>())
    }
}

enum ManifestFileFormat : String {
    case MP4 = "mp4"
}

enum ManifestTarget : String {
    case HDS = "HDS"
    case HLS = "HLS"
}
