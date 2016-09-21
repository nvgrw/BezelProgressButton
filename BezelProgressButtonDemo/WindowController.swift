//
//  WindowController.swift
//  BezelProgressButton
//
//  Created by Nik on 20/09/2016.
//  Copyright © 2016 Niklas Vangerow. All rights reserved.
//

import Cocoa
import BezelProgressButton

class WindowController: NSWindowController {

    @IBOutlet weak var progressButton: BezelProgressButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.titleVisibility = .hidden
        
        // Set this window controller as the view controller's delegate
        (self.contentViewController as? ViewController)?.delegate = self
    }

}

// MARK: - Implement ViewControllerDelegate
extension WindowController: ViewControllerDelegate {
    var progress: Double {
        get {
            return progressButton.progress
        }
        
        set {
            progressButton.progress = newValue
        }
    }
    
    var isInactive: Bool {
        get {
            return progressButton.isInactive
        }
    }
    
    func reset() {
        progressButton.resetProgress()
    }
}
