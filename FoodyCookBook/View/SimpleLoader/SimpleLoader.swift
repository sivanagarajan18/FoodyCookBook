//
//  ExpandableView.swift
//  DecEcom
//
//  Created by Siva on 22/01/20.
//  Copyright © 2020 Siva. All rights reserved.
//

import UIKit
@objc protocol Loaderdelagte: class {
    func masterViewLayout()
}

  class SimpleLoader: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak open var delegate: Loaderdelagte?
    let nibName = "SimpleLoader"
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        self.addSubview(view)
        indicator.startAnimating()
        contentView = view
        contentView.fixInView(self)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: SimpleLoader.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
 
}
