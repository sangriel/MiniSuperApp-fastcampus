//
//  UIViewController + Utils.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import Foundation
import UIKit

enum DismissButtonType {
    case back
    case close
    
    var iconSystemName : String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}
extension UIViewController {
    func setUpNavigationItem(with buttonType : DismissButtonType = .close, target : Any?, action : Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: buttonType.iconSystemName,
                           withConfiguration:
                            UIImage.SymbolConfiguration(pointSize: 18,weight: .semibold)),
            style: .plain,
            target: target,
            action: action)
    }
}
