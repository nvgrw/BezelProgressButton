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

/// Component that provides a progress bar in the bottom
/// of the button bezel, like seen in Safari and Xcode.
/// The effect is achieved using layers and masks, so
/// layer support is required. This component will set
/// wantsLayer = true on initialisation, so you shouldn't
/// need to do anything. This component only works for
/// textured rounded buttons located in the toolbar.
public class BezelProgressButton: NSButton {
    
    // Internal means of keeping track of progress
    private var _progress: Double = 0.0
    
    // Current progress to display for this button
    public var progress: Double {
        get {
            return _progress
        }
        
        set {
            // set the internal progress, but constrain the value to 0.0...1.0.
            _progress = max(0.0, min(newValue, 1.0))
            // update the progress layer because the progress value has changed
            updateProgress()
        }
    }
    
    // Keep track of progress status
    private(set) public var isInactive: Bool = true
    
    // Obtain the dimensions for the blue progress indicator
    private var progressRect: NSRect {
        var rect = maskRect
        let progressHeight = CGFloat(2.0)
        rect.origin.y = rect.height - progressHeight
        rect.size.height = progressHeight
        rect.origin.x = 0
        return rect
    }
    
    // Obtain the dimensions for the progress mask
    private var maskRect: NSRect {
        var rect = self.bounds
        rect.origin = CGPoint(x: 1, y: 2)
        rect.size.height -= 5
        rect.size.width -= 2
        return rect
    }
    
    // The two layers used to create the effect.
    private let progressLayer = CALayer()
    private let maskLayer = CALayer()
    
    // MARK: - Initialisers
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    // MARK: - Common initialiser
    private func commonInit() {
        // forcing textured rounded style as this button only works with this style
        bezelStyle = .texturedRounded
        wantsLayer = true
        // This component doesn't work without layers, so if the layer is nil we crash.
        self.layer!.masksToBounds = true
        
        // Set up the progress layer
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = NSColor.alternateSelectedControlColor.cgColor
        progressLayer.isHidden = true
        progressLayer.frame.size.width = 0.0
        
        // Set up the mask layer
        maskLayer.frame = maskRect
        maskLayer.masksToBounds = true
        maskLayer.cornerRadius = 4.0 // roughly the radius of the button so that there is no overlap.
        
        // Mask Layer -> Progress Layer -> Button Layer
        maskLayer.addSublayer(progressLayer)
        self.layer!.addSublayer(maskLayer)
        
        // Register for notifications so that the layers can be updated.
        NotificationCenter.default.addObserver(self, selector: #selector(frameChange(_:)), name: .NSViewFrameDidChange, object: self)
    }
    
    deinit {
        // Deregister from notifications.
        NotificationCenter.default.removeObserver(self, name: .NSViewFrameDidChange, object: self)
    }
    
    // MARK: - Notification handlers
    @objc private func frameChange(_ notification: Notification) {
        maskLayer.frame = maskRect
        progressLayer.frame = progressRect
        progressLayer.frame.size.width = maskLayer.bounds.width * CGFloat(_progress)
    }
    
    // MARK: - Progress mutation
    
    /// Update the progress layer width to reflect the current progress value.
    /// Also unhides the layer if it was previously hidden.
    public func updateProgress() {
        isInactive = false
        CATransaction.begin()
            if progressLayer.isHidden {
                progressLayer.isHidden = false
            }
        
            progressLayer.frame.size.width = maskLayer.bounds.width * CGFloat(_progress)
        CATransaction.commit()
    }
    
    /// Reset the progress layer to an inactive state.
    /// This means that the progress bar has 0 width and is hidden.
    public func resetProgress() {
        _progress = 0.0
        
        isInactive = true
        
        CATransaction.begin()
            progressLayer.isHidden = true
            CATransaction.setDisableActions(true)
            progressLayer.frame.size.width = 0.0
        CATransaction.commit()
    }
}
