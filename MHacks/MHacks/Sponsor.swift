//
//  Sponsor.swift
//  MHacks
//
//  Created by Russell Ladd on 11/24/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import Foundation

struct Sponsor: Equatable {
    
    let ID: String
    let name: String
    let description: String
    let website: NSURL
    let tier: Tier
    let location: Location
    let logo: PFFile
    
    struct Tier: Equatable, Comparable {
        
        let ID: String
        let name: String
        let level: Int
    }
}

extension Sponsor: Fetchable {
    
    init?(object: PFObject) {
        
        let name = object["name"] as? String
        let description = object["description"] as? String
        let websiteString = object["website"] as? String
        let tierObject = object["tier"] as? PFObject
        let locationObject = object["location"] as? PFObject
        let logo = object["logo"] as? PFFile
        
        if name == nil || description == nil || websiteString == nil || tierObject == nil || locationObject == nil || logo == nil {
            return nil
        }
        
        let website = NSURL(string: websiteString!)
        let tier = Tier(object: tierObject!)
        let location = Location(object: locationObject!)
        
        if (website == nil || tier == nil || location == nil) {
            return nil
        }
        
        self.ID = object.objectId
        self.name = name!
        self.description = description!
        self.website = website!
        self.tier = tier!
        self.location = location!
        self.logo = logo!
    }
}

extension Sponsor.Tier: Fetchable {
    
    init?(object: PFObject) {
        
        let name = object["name"] as? String
        let level = (object["level"] as? NSNumber)?.integerValue
        
        if (name == nil || level == nil) {
            return nil
        }
        
        self.ID = object.objectId
        self.name = name!
        self.level = level!
    }
}

func ==(lhs: Sponsor, rhs: Sponsor) -> Bool {
    
    // Logos are not compared because there is no way to compare PFFiles
    // Two instances of PFFile wrapping the same data are not equal
    
    return (lhs.ID == rhs.ID &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.website == rhs.website &&
        lhs.tier == rhs.tier &&
        lhs.location == rhs.location)
}

func ==(lhs: Sponsor.Tier, rhs: Sponsor.Tier) -> Bool {
    
    return (lhs.ID == rhs.ID &&
        lhs.name == rhs.name &&
        lhs.level == rhs.level)
}

func <(lhs: Sponsor.Tier, rhs: Sponsor.Tier) -> Bool {
    return lhs.level < rhs.level
}
