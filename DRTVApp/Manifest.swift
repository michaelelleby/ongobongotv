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
    var hardSubtitlesType: HardSubtitlesType
    var format: ManifestFileFormat
    var target: ManifestTarget
    
    init?(map: Map) {
        hardSubtitlesType = .Unknown
        format = .Unknown
        target = .Unknown
    }
    
    mutating func mapping(map: Map) {
        uri <- (map["Uri"], URLTransform(shouldEncodeURLString: true))
        encryptedUri <- (map["EncryptedUri"], URLTransform(shouldEncodeURLString: true))
        hardSubtitlesType <- (map["HardSubtitlesType"],EnumTransform<HardSubtitlesType>())
        format <- (map["FileFormat"],EnumTransform<ManifestFileFormat>())
        target <- (map["Target"],EnumTransform<ManifestTarget>())
    }
}

enum ManifestFileFormat : String {
    case Unknown
    case MP4 = "mp4"
}

enum ManifestTarget : String {
    case Unknown = "Unknown"
    case Download = "Download"
    case HDS = "HDS"
    case HLS = "HLS"
}

enum HardSubtitlesType : String {
    case Unknown
    case ForeignLanguage = "ForeignLanguage"
}
