//
//  MyFooter.swift
//  AsyncTableView
//
//  Created by ischuetz on 27/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation
import UIKit

class MyFooter : UIView {
    
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    
    override var hidden:Bool {
        get {
            return super.hidden
        }
        set(hidden) {
            super.hidden = hidden

//            if self.activityIndicator {
//                if hidden {
//                    self.activityIndicator.startAnimating()
//                } else {
//                    self.activityIndicator.stopAnimating()
//                }
//            }
        }
    }
    
    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
    }
}