//
//  MostViewedEntity.swift
//  DRTVApp
//
//  Created by Michael on 29/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

import Foundation
import ObjectMapper

class MostViewedEntity : Mappable {
    var programCard: ProgramCard?
    var totalViews: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.programCard <- map["ProgramCard"]
        self.totalViews <- map["TotalViews"]
    }
}
