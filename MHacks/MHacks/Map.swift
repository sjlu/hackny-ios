//
//  Map.swift
//  MHacks
//
//  Created by Ben Oztalay on 12/21/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import UIKit

struct Map: Equatable {
   
    let ID: String
    let title: String
    let image: PFFile
}

extension Map: Fetchable {
    
    init?(object: PFObject) {
        
        let title = object["title"] as? String
        let image = object["image"] as? PFFile
        
        if (title == nil || image == nil) {
            return nil
        }
        
        self.ID = object.objectId
        self.title = title!
        self.image = image!
    }
}

func ==(lhs: Map, rhs: Map) -> Bool {
    
    // Images are not compared because there is no way to compare PFFiles
    // Two instances of PFFile wrapping the same data are not equal
    
    return (lhs.ID == rhs.ID &&
        lhs.title == rhs.title)
}