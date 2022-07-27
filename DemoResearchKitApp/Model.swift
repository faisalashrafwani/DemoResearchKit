//
//  Model.swift
//  DemoResearchKitApp
//
//  Created by admin on 22/07/22.
//

import Foundation
struct Model: Hashable {
    var id: Int
    var dateTimeCapture: String
    var name: String
    var qualification: String
    var adventureType: String
    
    
    init(_ id: Int, _ name: String, _ dateTimeCapture: String, _ qualification: String, _ adventureType: String){
        self.id = id
        self.name = name
        self.qualification = qualification
        self.adventureType = adventureType
        self.dateTimeCapture = dateTimeCapture
    }
}
