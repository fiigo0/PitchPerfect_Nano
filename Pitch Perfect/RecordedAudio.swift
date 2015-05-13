//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Diaz Orona, Jesus A. on 5/7/15.
//  Copyright (c) 2015 JADO. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
        
    init(title:String, andFilePathURL filePath:NSURL) {
        self.filePathUrl = filePath
        self.title = title
    }
    
}