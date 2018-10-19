//
//  UIViewController+drag.swift
//  dbr
//
//  Created by Ray Krow on 10/18/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

enum DraggableEvent {
    case move
    case snapToMin
    case snapToMax
}

typealias DraggableEventHandler = (CGFloat) -> Void

class DraggableEventBus {
    
    let disposeBag = DisposeBag()
    let view: UIView
    var eventHandlers = [DraggableEvent: [DraggableEventHandler]]()
    var fingerDragOffset: CGFloat = 0.0
    
    let min: CGFloat
    let max: CGFloat
    let half: CGFloat
    
    init(for view: UIView, min: CGFloat, max: CGFloat) {
        
        self.min = min
        self.max = max
        self.half = (max - min) / 2
        self.view = view
        
        let gesture = view.rx.panGesture()
        
        gesture.when(.began)
            .subscribe(onNext: self.onPanBegin)
            .disposed(by: self.disposeBag)
        
        gesture.when(.ended)
            .subscribe(onNext: self.onPanEnd)
            .disposed(by: self.disposeBag)
        
        gesture.when(.changed)
            .subscribe(onNext: self.onPanChange)
            .disposed(by: self.disposeBag)
        
    }
    
    @discardableResult
    func on(_ event: DraggableEvent, _ handler: @escaping DraggableEventHandler) -> DraggableEventBus {
        var handlers = eventHandlers[event] ?? []
        handlers.append(handler)
        eventHandlers[event] = handlers
        
        return self // +chainable
    }
    
    @discardableResult
    func on(_ events: [DraggableEvent], _ handler: @escaping DraggableEventHandler) -> DraggableEventBus {
        events.forEach { self.on($0, handler) }
        return self // +chainable
    }
    
}


extension DraggableEventBus {
    
    private func fire(_ event: DraggableEvent, value: CGFloat) {
        let handlers = eventHandlers[event] ?? []
        handlers.forEach { handler in
            handler(value)
        }
    }
    
    private func onPanBegin(_ recognizer: UIPanGestureRecognizer) -> Void {
        let touch = recognizer.location(ofTouch: 0, in: self.view.superview)
        self.fingerDragOffset = touch.x - self.view.frame.minX
    }
    
    private func onPanChange(_ recognizer: UIPanGestureRecognizer) -> Void {
        let point = recognizer.location(ofTouch: 0, in: self.view.superview)
        guard point.x != 0.0 else { return }
        
        let newX = point.x - self.fingerDragOffset
        
        guard min < newX && newX < max else { return }
        
        self.fire(.move, value: newX)
    }
    
    private func onPanEnd(_ recognizer: UIPanGestureRecognizer) -> Void {
        
        // Decide if the view is currenly closer to
        // open or close and then snap it to that side
        if self.view.frame.minX >= half {
            self.fire(.snapToMax, value: max)
        } else {
            self.fire(.snapToMin, value: min)
        }
        
         self.fingerDragOffset = 0.0
    }
    
}

extension UIViewController {
    
    func draggable(min: CGFloat?, max: CGFloat?) -> DraggableEventBus {
        let mn = min ?? 0.0
        let mx = max ?? UIScreen.main.bounds.maxX - self.view.bounds.width
        
        return DraggableEventBus(for: self.view, min: mn, max: mx)
    }
    
    
}
