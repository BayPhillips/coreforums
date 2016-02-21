//
//  ConcurrencyHelper.swift
//  CoreForums
//
//  Created by Bay Phillips on 2/21/16.
//  Copyright © 2016 Bay Phillips. All rights reserved.
//

import Foundation

class Concurrency {
    static func runOnMainThread(closure: () -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            closure()
        }
    }
    
    static func runOnBackgroundThread(closure: () -> ()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            closure()
        }
    }
}