//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation
import Combine
import CombineExt

public class ReadOnlyCurrentValuePublisher<Element> : Publisher {
    
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value : Element {
        currentValueRelay.value
    }
    
    fileprivate let currentValueRelay : CurrentValueRelay<Output>
    
    fileprivate init(initialValue : Element) {
        self.currentValueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber : S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentValueRelay.receive(subscriber: subscriber)
    }
}

public class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    public typealias Output = Element
    public typealias Failure = Never
    
    public override init(initialValue: Element) {
        super.init(initialValue: initialValue)
    }
    
    public func send(_ value : Element) {
        currentValueRelay.accept(value)
    }
}
