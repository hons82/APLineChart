//
//  APChartLine.swift
//  linechart
//
//  Created by Attilio Patania on 20/03/15.
//  Copyright (c) 2015 zemirco. All rights reserved.
//

import UIKit
import QuartzCore


public class APChartLine  {
    var chart:APChartView!
    var dots:[APChartPoint] = []
    var title:String = "line"
    var lineColor:UIColor = UIColor.blackColor()
    var lineWidth:CGFloat = 2.0
    var showMeanValue:Bool = false
    var meanValue:CGFloat = 0.0
    var meanCoord:CGFloat = 0.0
    var showMeanValueProgressive:Bool = false
    var meanCoordsProgressive:[CGFloat] = []
    var extra:[String:AnyObject!] = [:]
    
    
    public init(chartView:APChartView, title:String, points:[APChartPoint]) {
        self.chart = chartView
        self.title = title
        self.dots = points
    }
    public init(chartView:APChartView, title:String, lineWidth:CGFloat, lineColor:UIColor) {
        self.chart = chartView
        self.title = title
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
    
    public func addPoint(point:CGPoint) {

        let dot = APChartPoint(point)
        dot.chart = chart
        dot.color = lineColor
        self.dots.append(dot)
        
    }
    public func addPoint(point:CGPoint, extra:[String:AnyObject!]) {

        let dot = APChartPoint(point)
        dot.chart = chart
        dot.color = lineColor
        dot.extra = extra
        self.dots.append(dot)
        
    }
    public func clear(){
        dots.removeAll()
    }
    

    func updatePoints(factorPoint:CGPoint, offset:CGPoint){
       
        for (index, dot) in dots.enumerate(){
            dots[index] = dot.updatePoint(factorPoint, offset: offset)
        }

    }
    
    func drawLine() -> CAShapeLayer? {

        let bpath = UIBezierPath()

        bpath.moveToPoint(CGPoint(x: dots[0].point.x, y: dots[0].point.y))
        
        for (index, dot) in dots.enumerate() {
            
            bpath.addLineToPoint(dot.point)
            if showMeanValue {
                if index == 0 {
                    meanValue = dot.dot.y
                    meanCoord = dot.point.y
                    meanCoordsProgressive.append(meanCoord)
                    continue
                }
                meanValue = (CGFloat(index)*meanValue +  dot.dot.y ) / CGFloat(index+1)
                meanCoord = (CGFloat(index)*meanCoord +  dot.point.y ) / CGFloat(index+1)
                meanCoordsProgressive.append(meanCoord)
                
            }
        }
        
        UIColor.clearColor().setStroke()
        bpath.lineCapStyle = .Round
        bpath.stroke()
//
        let layer = CAShapeLayer()
        layer.frame = self.chart.bounds
        layer.path = bpath.CGPath
        layer.strokeColor = lineColor.CGColor //colors[lineIndex].CGColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth

        let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 1.0
            animation.fromValue = 0
            animation.toValue = 1
            layer.addAnimation(animation, forKey: "strokeEnd")
    
        return layer
    }

    func drawDots(bgColor:UIColor) -> [CALayer]? {
        var retLayers:[CALayer]? = []
        for currDot in dots {
            currDot.backgroundColor = lineColor
            retLayers?.append(currDot.drawDot(bgColor))
        }
        return retLayers
    }
    
    /**
    * Fill area between line chart and x-axis.
    */
    func drawAreaBeneathLineChart() {

        let bpath = UIBezierPath()
        bpath.moveToPoint(CGPoint(x: dots[0].point.x, y: chart.pointZero.y))
        for dot in dots {
            bpath.addLineToPoint(dot.point)
        }
        bpath.addLineToPoint(CGPoint(x: dots[dots.count-1].point.x, y: chart.pointZero.y))
        let bgColor = lineColor.lighterColorForColor()
        
        bgColor.setFill()
        bpath.lineCapStyle = .Round
        bpath.fill()
        bpath.stroke()
        
    }

    func drawMeanProgressive(){
        if !showMeanValueProgressive || meanCoordsProgressive.count == 0 {
            return
        }
        
        let meanPath = UIBezierPath()
        meanPath.moveToPoint(CGPoint(x: dots[0].point.x, y: meanCoordsProgressive[0]))
        for (index,curr) in dots.enumerate() {
            meanPath.addLineToPoint(CGPoint(x: curr.point.x, y: meanCoordsProgressive[index]))
            
        }
        
        
        meanPath.lineWidth = 1.0
        meanPath.stroke()
        
        //
        let layer = CAShapeLayer()
        layer.frame = chart.bounds
        layer.path = meanPath.CGPath
        layer.strokeColor = lineColor.CGColor //colors[lineIndex].CGColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        layer.lineDashPattern = [6,2,8,2]
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0
        animation.toValue = 1
        layer.addAnimation(animation, forKey: "strokeEnd")

        let lblMean = UILabel(frame: CGRect(origin: CGPoint(x: chart.drawingArea.origin.x, y: meanCoord), size: chart.labelAxesSize))
        lblMean.font = UIFont.italicSystemFontOfSize(10.0)
        lblMean.textAlignment = .Left
        lblMean.text = "\(meanValue.round2dec())"
        lblMean.textColor = lineColor
        chart.addSubview(lblMean)
        chart.layer.addSublayer(layer)
        chart.lineLayerStore.append(layer)
        
    }
    
    func drawMeanValue(){
        if !showMeanValue || meanValue == 0.0  {
            return
        }
        
        let meanPath = UIBezierPath()
        meanPath.moveToPoint(CGPoint(x: chart.drawingArea.origin.x, y: meanCoord))
        meanPath.addLineToPoint(CGPoint(x: chart.drawingArea.origin.x+chart.drawingArea.width, y: meanCoord))
        
        meanPath.setLineDash([6,2], count: 3, phase: 1.0)
        meanPath.lineWidth = 1.0
        meanPath.stroke()
        
        //
        let layer = CAShapeLayer()
        layer.frame = chart.bounds
        layer.path = meanPath.CGPath
        layer.strokeColor = lineColor.CGColor //colors[lineIndex].CGColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        layer.lineDashPattern = [6,2]
//        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0
        animation.toValue = 1
        layer.addAnimation(animation, forKey: "strokeEnd")
        let lblMean = UILabel(frame: CGRect(origin: CGPoint(x: chart.drawingArea.origin.x, y: meanCoord), size: chart.labelAxesSize))
        lblMean.font = UIFont.italicSystemFontOfSize(10.0)
        lblMean.textAlignment = .Left
        lblMean.text = "\(meanValue.round2dec())"
        lblMean.textColor = lineColor
        chart.addSubview(lblMean)
        chart.layer.addSublayer(layer)
        chart.lineLayerStore.append(layer)

    }

}
