//
//  ViewController.swift
//  BezelProgressButtonDemo
//
//  Created by Nik on 20/09/2016.
//  Copyright © 2016 Niklas Vangerow. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, StoryboardIdentifiable {

    static let identifier: String = "primaryContentViewController"
    
    var timerPaused: Bool = true
    let timer = DispatchSource.makeTimerSource()
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer.setEventHandler {
            guard let vc = self.delegate else {
                return
            }
            
            let newProgress = vc.progress + 0.1
            if newProgress > 1.0 {
                vc.reset()
            } else {
                vc.progress = newProgress
            }
        }
        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(100))
    }
    
    deinit {
        timer.suspend()
        timer.cancel()
    }
}

// MARK: - Action handlers
extension ViewController {
    
    @IBAction func startStopAction(_ sender: NSButton) {
        if timerPaused {
            timer.resume()
        } else {
            timer.suspend()
        }
        
        timerPaused = !timerPaused
    }
    
    @IBAction func resetAction(_ sender: NSButton) {
        delegate?.reset()
    }
}

protocol ViewControllerDelegate: class {
    var progress: Double { get set }
    var isInactive: Bool { get }
    
    func reset()
}

