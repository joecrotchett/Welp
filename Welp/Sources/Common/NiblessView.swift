//
//  NiblessView.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit

// Reader note: When building views programmatically, I like use a view subclass
// such as this to 1) express intent to other developers, 2) cleanup the intializers
// used in IB-built views, and 3) enforce programmatic constraints

class NiblessView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable, message: "Loading this view from a nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported")
    }
}
