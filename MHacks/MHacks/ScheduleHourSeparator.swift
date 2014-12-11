//
//  ScheduleHourSeparator.swift
//  MHacks
//
//  Created by Russell Ladd on 10/7/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import UIKit

class ScheduleHourSeparator: UICollectionReusableView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet private weak var separatorHeightConstraint: NSLayoutConstraint!
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        separatorHeightConstraint.constant = Geometry.hairlineWidthInTraitCollection(traitCollection)
    }
}
