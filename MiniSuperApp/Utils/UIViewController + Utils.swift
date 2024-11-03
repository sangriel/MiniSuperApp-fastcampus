//
//  UIViewController + Utils.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import Foundation
import UIKit


extension UIViewController {
    func setUpNavigationItem(target : Any?, action : Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark",
                           withConfiguration:
                            UIImage.SymbolConfiguration(pointSize: 18,weight: .semibold)),
            style: .plain,
            target: target,
            action: action)
    }
}
