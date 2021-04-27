//
//  loader.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import Foundation
import UIKit
var loaderView: SimpleLoader!
class loader {
    static func loadLoader(_ view: UIView, load: Bool){
        if load {
            loaderView = SimpleLoader(frame: view.frame)
            view.addSubview(loaderView)
        } else {
            if loaderView != nil {
                let sub = view.subviews
                for load in sub {
                    if load.isKind(of: SimpleLoader.self) {
                        load.removeFromSuperview()
                    }
                }
            }
        }
    }
}
