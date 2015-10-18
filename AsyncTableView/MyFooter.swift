//
//  MyFooter.swift
//  AsyncTableView
//
//  Created by ischuetz on 27/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class MyFooter: UIView {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        self.activityIndicator.startAnimating()
    }
}