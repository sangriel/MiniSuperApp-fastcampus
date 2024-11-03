//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/2/24.
//

import Foundation
import UIKit


protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

final class AdaptivePresentationControllerDelegateProxy : NSObject, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate : AdaptivePresentationControllerDelegate?
    
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
    
}
