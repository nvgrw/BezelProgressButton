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

