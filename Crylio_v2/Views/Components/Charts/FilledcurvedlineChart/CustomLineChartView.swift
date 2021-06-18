//
//  CustomLineChartView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 12/06/2021.
//

import UIKit


struct PointEntry {
    
    let value: Float
    let label: String
}

extension PointEntry: Comparable {
    
    static func <(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value < rhs.value
    }
    static func ==(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}


class CustomLineChartView: UIView {
    
    /// Contains the main line which represents the data
    private var dataLayer: CALayer = CALayer()
    
    /// Contains the main line which represents the data
    private var lineLayer: CAShapeLayer = CAShapeLayer()
    
    /// Line chart top offset
    var topOffset: CGFloat = 20.0
    
    var shadow = true
    
    var lineWidth: CGFloat = 0.0
    var lineColor: UIColor = .black
    
    /// Contains shadow of the line
    private var shadowLayer: CALayer = CALayer()
    
    let bezierPath = UIBezierPath()
    
    var points = [CGPoint]()
    
    var pointEntries = [PointEntry]()
    
    var fillColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dataLayer.frame.size = frame.size
        lineLayer.frame.size = frame.size
        if shadow {
            shadowLayer.frame.size = frame.size
        }
        
        update()
    }
    
    func setupView() {
        
        clean()
        
        backgroundColor = .clear
        
        layer.addSublayer(dataLayer)
        dataLayer.addSublayer(lineLayer)
        
        dataLayer.frame.size = frame.size
        lineLayer.frame.size = frame.size
        if shadow {
            shadowLayer.frame.size = frame.size
        }
        
        dataLayer.contentsScale = UIScreen.main.scale
        lineLayer.contentsScale = UIScreen.main.scale
        shadowLayer.contentsScale = UIScreen.main.scale
    }
    
    func update() {
                
        convertPointEntryToCGPoint()
        
        let config = BezierConfiguration()
        let controlPoints = config.configureControlPoints(data: points)
        
        for i in 0..<points.count {
            let point = points[i]
            if i == 0 {
                bezierPath.move(to: point)
            } else {
                let segment = controlPoints[i - 1]
                bezierPath.addCurve(to: point, controlPoint1: segment.firstControlPoint, controlPoint2: segment.secondControlPoint)
            }
        }
        
        if fillColor != .clear {
            bezierPath.close()
        }
        
        lineLayer.path = bezierPath.cgPath
        lineLayer.lineWidth = lineWidth
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.fillColor = fillColor.cgColor
        
        if shadow {
            shadowLayer = createShadowLayer()
            shadowLayer.insertSublayer(lineLayer, at: 0)
            dataLayer.addSublayer(shadowLayer)
        } else {
            dataLayer.addSublayer(lineLayer)
        }
    }
    
    private func convertPointEntryToCGPoint() {
        
        var points = [CGPoint]()
        
        let pointGap = frame.width / CGFloat(pointEntries.count-1)
        
        if fillColor != .clear {
            points.append(CGPoint(x: 0, y: frame.height))
        }
        
        if let max = pointEntries.max()?.value, let min = pointEntries.min()?.value {
            for (i, entry) in pointEntries.enumerated() {
                
                let percent = 1 - entry.value / max
                
                //  let percent = 1 - (point.value - min * 0.9) / (max - min * 0.9)

                
                let point = CGPoint(x: CGFloat(i) * pointGap, y: frame.height * CGFloat(percent))
                
                //print(entry.value, frame.height * CGFloat(percent))
                
                points.append(point)
            }
        }
        
        if fillColor != .clear {
            points.append(CGPoint(x: frame.width, y: frame.height))
        }
        
        self.points = points
    }
    
    private func createPoints() {
        
        for point in points {
            let circleLayer = CAShapeLayer()
            circleLayer.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            circleLayer.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
            circleLayer.fillColor = UIColor.red.cgColor
            circleLayer.position = point
            layer.addSublayer(circleLayer)
        }
    }
    
    private func createShadowLayer() -> CALayer {
        
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: -3)
        shadowLayer.shadowRadius = 10
        shadowLayer.shadowOpacity = 0.07
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        
        return shadowLayer
    }
    
    private func clean() {
        
        layer.sublayers?.forEach({
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        lineLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
}
