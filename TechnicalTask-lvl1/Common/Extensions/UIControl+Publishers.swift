//
//  UIControl+Publishers.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Combine
import UIKit

protocol ControlWithPublisher: UIControl {}
extension UIControl: ControlWithPublisher {}

extension ControlWithPublisher {
    func publisher(for event: UIControl.Event = .primaryActionTriggered) -> ControlPublisher<Self> {
        ControlPublisher(control: self, for: event)
    }
}

struct ControlPublisher<T: UIControl>: Publisher {
    typealias Output = T
    typealias Failure = Never

    unowned let control: T
    let event: UIControl.Event

    init(control: T, for event: UIControl.Event = .primaryActionTriggered) {
        self.control = control
        self.event = event
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
        subscriber.receive(subscription: Inner(downstream: subscriber, sender: control, event: event))
    }

    class Inner<S: Subscriber>: NSObject, Subscription where S.Input == Output, S.Failure == Failure {
        weak var sender: T?
        let event: UIControl.Event
        var downstream: S?

        init(downstream: S, sender: T, event: UIControl.Event) {
            self.downstream = downstream
            self.sender = sender
            self.event = event
            super.init()
        }

        func request(_: Subscribers.Demand) {
            sender?.addTarget(self, action: #selector(doAction), for: event)
        }

        @objc public func doAction(_: UIControl) {
            guard let sender else { return }
            _ = downstream?.receive(sender)
        }

        private func finish() {
            sender?.removeTarget(self, action: #selector(doAction), for: event)
            sender = nil
            downstream = nil
        }

        func cancel() {
            finish()
        }

        deinit {
            finish()
        }
    }
}
