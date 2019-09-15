//
//  AAMaterialSpinner.swift
//  AAMaterialSpinner
//
//  Created by MacBook Pro on 08/03/2019.
//

import UIKit

open class AAMaterialSpinner: UIView {
    
    var timer: Timer?
    public let circleLayer = CAShapeLayer()
    open private(set) var isAnimating = false
    open var animationDuration : TimeInterval = 2.0
    open var colorArray: [UIColor] = [.red]
    var colorCounter: Int = 0 {
        didSet(val) {
            if val >= colorArray.count - 1 {
                self.colorCounter = 0
            }
            circleLayer.strokeColor = colorArray[colorCounter].cgColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.layer.addSublayer(circleLayer)
        
        circleLayer.fillColor = nil
        circleLayer.lineWidth = 2.0
        
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0
        
        #if swift(>=4.2)
        circleLayer.lineCap = CAShapeLayerLineCap.round
        #else
        circleLayer.lineCap = kCALineCapRound
        #endif
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.circleLayer.frame != self.bounds {
            updateCircleLayer()
        }
    }
    
    func updateCircleLayer() {
        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        let radius = (self.bounds.height - self.circleLayer.lineWidth) / 2.0
        
        let startAngle : CGFloat = 0.0
        let endAngle : CGFloat = 2.0 * CGFloat.pi
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        self.circleLayer.path = path.cgPath
        self.circleLayer.frame = self.bounds
    }
    
    var animationObject: CAAnimationGroup {
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotateAnimation.values = [
            0.0,
            Float.pi,
            (2.0 * Float.pi)
        ]
        
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = (self.animationDuration / 2.0)
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = (self.animationDuration / 2.0)
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        
        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.beginTime = (self.animationDuration / 2.0)
        endHeadAnimation.duration = (self.animationDuration / 2.0)
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1
        
        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = (self.animationDuration / 2.0)
        endTailAnimation.duration = (self.animationDuration / 2.0)
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1
        
        let animations = CAAnimationGroup()
        animations.duration = self.animationDuration
        animations.animations = [
            rotateAnimation,
            headAnimation,
            tailAnimation,
            endHeadAnimation,
            endTailAnimation
        ]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        return animations

    }
    
    open func forceBeginRefreshing() {
        self.isAnimating = false
        self.beginRefreshing()
    }
    
    open func beginRefreshing() {
        
        if(self.isAnimating) { return }
        self.isAnimating = true
        
        (colorCounter = colorCounter)
        
        if colorArray.count > 1 {
            timer = Timer.scheduledTimer(timeInterval: self.animationDuration, target: self, selector: #selector(timerDidTrigger), userInfo: nil, repeats: true)
        }
        
        self.circleLayer.add(animationObject, forKey: "animations")
        
    }
    
    @objc func timerDidTrigger() {
        colorCounter += 1
    }
    
    open func endRefreshing() {
        timer?.invalidate()
        timer = nil
        colorCounter = 0
        self.isAnimating = false
        self.circleLayer.removeAnimation(forKey: "animations")
    }
    
    
}

