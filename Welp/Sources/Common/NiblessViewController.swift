//
//  NiblessViewController.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit

// Reader note: When building view controllers programmatically, I like use a
// view controller subclass such as this to 1) express intent to other developers, 2) cleanup
// the intializers used in IB-built view controllers, and 3) enforce programmatic constraints
class NiblessViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    // Enforce programmatically built view controllers intializers only
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: UIKit.Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported")
    }
}
