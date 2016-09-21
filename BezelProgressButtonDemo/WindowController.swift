/*
 MIT License
 
 Copyright (c) 2016 Niklas Vangerow
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

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
