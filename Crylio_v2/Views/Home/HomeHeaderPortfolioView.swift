//
//  HomeHeaderPortfolioView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 09/02/2021.
//

import UIKit


class HomeHeaderPortfolioView: UIView {
    
    lazy var circle1 = UIView()
    lazy var circle2 = UIView()
    lazy var circle3 = UIView()
    
    lazy var blurredView = UIView()
    lazy var darkView = UIView()
    
    var circle1OriginCenter: CGPoint!
    var circle2OriginCenter: CGPoint!
    var circle3OriginCenter: CGPoint!
    
    var backgroundLoadingAnimation: UIViewPropertyAnimator!
    lazy var chartLoadingAnimation = UIView()
    
    
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    
    /// The `CAShapeLayer` that will contain the animated path
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        return shapeLayer
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .systemGray
        
        layer.masksToBounds = true
        clipsToBounds = true
        
        circle1.backgroundColor = .systemGray2
        circle2.backgroundColor = .systemGray2
        circle3.backgroundColor = .systemGray2
        
        circle1.clipsToBounds = true
        circle2.clipsToBounds = true
        circle3.clipsToBounds = true
        
        blurredView.addBurEffect()
        blurredView.addBurEffect()
        
        darkView.backgroundColor = .black
        darkView.alpha = 0.5
        
         
        addSubview(circle1)
        addSubview(circle2)
        addSubview(circle3)
        
        addSubview(blurredView)
        
        addSubview(darkView)
        
        addSubview(chartLoadingAnimation)

        
        layer.addSublayer(shapeLayer)
        
    }
    
    func setNewAnimationsForCircleViews() {
        
        let circle1NewPosition = getNewRandomPosition(center: circle1OriginCenter)
        let circle2NewPosition = getNewRandomPosition(center: circle2OriginCenter)
        let circle3NewPosition = getNewRandomPosition(center: circle3OriginCenter)
        
        //        let circle1XNewScale = CGFloat.random(in: 0.8..<1)
        //        let circle2XNewScale = CGFloat.random(in: 0.8..<1)
        //        let circle3XNewScale = CGFloat.random(in: 0.8..<1)
        //
        //        let circle1YNewScale = CGFloat.random(in: 0.8..<1)
        //        let circle2YNewScale = CGFloat.random(in: 0.8..<1)
        //        let circle3YNewScale = CGFloat.random(in: 0.8..<1)
        
        let animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut)
        
        animator.addAnimations {
            self.circle1.transform = CGAffineTransform(translationX: circle1NewPosition.x - self.circle1OriginCenter.x, y: circle1NewPosition.y - self.circle1OriginCenter.y) //.concatenating(CGAffineTransform(scaleX: circle1XNewScale, y: circle1YNewScale))
            self.circle2.transform = CGAffineTransform(translationX: circle2NewPosition.x - self.circle2OriginCenter.x, y: circle2NewPosition.y - self.circle2OriginCenter.y) //.concatenating(CGAffineTransform(scaleX: circle2XNewScale, y: circle2YNewScale))
            self.circle3.transform = CGAffineTransform(translationX: circle3NewPosition.x - self.circle3OriginCenter.x, y: circle3NewPosition.y - self.circle3OriginCenter.y) //.concatenating(CGAffineTransform(scaleX: circle3XNewScale, y: circle3YNewScale))
        }
        
        
        animator.addCompletion { _ in
            self.setNewAnimationsForCircleViews()
            self.backgroundLoadingAnimation.startAnimation()
        }
        
        backgroundLoadingAnimation = animator
    }
    
    func getNewRandomPosition(center: CGPoint) -> CGPoint {
        let r = self.frame.width * CGFloat.random(in: 0.05..<0.15)
        
        let theta = CGFloat.random(in: 0..<1) * 2 * CGFloat.pi
        
        let x = center.x + r * cos(theta)
        let y = center.y + r * sin(theta)
        
        return CGPoint(x: x, y: y)
    }
    
    func getRandomCoordinates() -> [CGPoint] {
        
        var coordinates = [CGPoint]()
        
        coordinates.append(CGPoint(x: self.frame.width * 0.15, y: self.frame.height * 0.78))
        coordinates.append(CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.1))
        coordinates.append(CGPoint(x: self.frame.width * 0.85, y: self.frame.height * 0.657))
        
        return coordinates.shuffled()
    }
    
    func startLoadingAnimation() {
        
        setNewAnimationsForCircleViews()
        backgroundLoadingAnimation.startAnimation()
        
        startDisplayLink()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            print("STOP")
            self.backgroundLoadingAnimation.stopAnimation(true)
            self.startGreenAnimation()
        }
    }
    
    func stopLoadingAnimation() {
        backgroundLoadingAnimation.stopAnimation(true)
    }
    
    func startGreenAnimation() {
        
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
        
        animator.addAnimations {
            self.circle1.transform = CGAffineTransform(translationX: self.circle3OriginCenter.x - self.circle1.center.x, y: self.circle3OriginCenter.y - self.circle1.center.y) //.concatenating(CGAffineTransform(scaleX: circle1XNewScale, y: circle1YNewScale))
            self.circle2.transform = CGAffineTransform(translationX: self.circle2OriginCenter.x - self.circle2.center.x, y: self.circle2OriginCenter.y - self.circle2.center.y) //.concatenating(CGAffineTransform(scaleX: circle2XNewScale, y: circle2YNewScale))
            self.circle3.transform = CGAffineTransform(translationX: self.circle1OriginCenter.x - self.circle3.center.x, y: self.circle1OriginCenter.y - self.circle3.center.y) //.concatenating(CGAffineTransform(scaleX: circle3XNewScale, y: circle3YNewScale))
            
            self.backgroundColor = .systemBackground
            self.circle1.backgroundColor = UIColor(red: 0.09, green: 0.24, blue: 0.18, alpha: 1.00)
            self.circle2.backgroundColor = UIColor(red: 0.09, green: 0.24, blue: 0.18, alpha: 1.00)
            self.circle3.backgroundColor = UIColor(red: 0.09, green: 0.24, blue: 0.18, alpha: 1.00)
        }
        animator.startAnimation()
    }
    
    
    override func updateConstraints() {
        
        let coordinates = getRandomCoordinates()
        
        circle1OriginCenter = coordinates[0]
        circle2OriginCenter = coordinates[1]
        circle3OriginCenter = coordinates[2]
        
        circle1.snp.remakeConstraints { make in
            make.width.height.equalTo(snp.width).multipliedBy(0.6)
            make.center.equalTo(circle1OriginCenter)
        }
        
        circle2.snp.remakeConstraints { make in
            make.width.height.equalTo(snp.width).multipliedBy(0.5)
            make.center.equalTo(circle2OriginCenter)
        }
        
        circle3.snp.remakeConstraints { make in
            make.width.height.equalTo(snp.width).multipliedBy(0.4)
            make.center.equalTo(circle3OriginCenter)
        }
        
        blurredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        darkView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        chartLoadingAnimation.snp.makeConstraints { make in
            make.left.bottom.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 7
        
        circle1.layer.cornerRadius = circle1.frame.size.width/2
        circle2.layer.cornerRadius = circle2.frame.size.width/2
        circle3.layer.cornerRadius = circle3.frame.size.width/2
                        
        setNeedsUpdateConstraints()
        
    }
    
}

extension UIView {
    
    func addBurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}


extension HomeHeaderPortfolioView {
    
    /// Start the display link
    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        self.displayLink?.invalidate()
        let displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    /// Stop the display link
    private func stopDisplayLink() {
        displayLink?.invalidate()
    }
    
    /// Handle the display link timer.
    ///
    /// - Parameter displayLink: The display link.
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        shapeLayer.path = wave(at: elapsed/2).cgPath
    }
    
    /// Create the wave at a given elapsed time.
    ///
    /// You should customize this as you see fit.
    ///
    /// - Parameter elapsed: How many seconds have elapsed.
    /// - Returns: The `UIBezierPath` for a particular point of time.
    private func wave(at elapsed: Double) -> UIBezierPath {
        let elapsed = CGFloat(elapsed)
        let centerY = bounds.midY + bounds.height/4
        let amplitude = 50 - abs(elapsed.remainder(dividingBy: 3)) * 40
        
        func f(_ x: CGFloat) -> CGFloat {
            return sin((x + elapsed) * 4 * .pi) * amplitude + centerY
        }
        
        let path = UIBezierPath()
        let steps = Int(bounds.width / 10)
        
        path.move(to: CGPoint(x: 0, y: f(0)))
        for step in 1 ... steps {
            let x = CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x * bounds.width, y: f(x)))
        }
        
        return path
    }
}
