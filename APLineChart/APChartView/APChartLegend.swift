//
//  APChartLegend.swift
//  Pods
//
//  Created by Hannes Tribus on 13/11/15.
//
//

import UIKit
import CoreGraphics
import Darwin

class APChartLegend: UIView {
    
    let PADDING:CGFloat = 5
    let COLORPADDING:CGFloat = 15
    
    lazy var collectionLines: [APChartLine] = []
    lazy var titlesFont: UIFont = UIFont.systemFontOfSize(10)
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        if let c = UIGraphicsGetCurrentContext() {
            CGContextSetFillColorWithColor(c, UIColor(white: 0.0, alpha: 0.1).CGColor)
            CGContextFillRoundedRect(c, rect: bounds, radius: 7.0)
            
            var y:CGFloat = 0
            for line in collectionLines {
                line.lineColor.setFill()
                CGContextFillEllipseInRect(c, CGRectMake(PADDING + 2, PADDING + round(y) + titlesFont.xHeight / 2 + 1, 6, 6))
                UIColor.whiteColor().set()
                let textFontAttributes = [
                    NSFontAttributeName : titlesFont,
                    NSForegroundColorAttributeName: line.lineColor
                ]
                (line.title as NSString).drawAtPoint(CGPointMake(COLORPADDING + PADDING, y + PADDING), withAttributes: textFontAttributes)
                y += titlesFont.lineHeight
            }
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let h:CGFloat = titlesFont.lineHeight * CGFloat(collectionLines.count)
        var w:CGFloat = 0
        for line in collectionLines {
            let textFontAttributes = [
                NSFontAttributeName : titlesFont,
                NSForegroundColorAttributeName: line.lineColor
            ]
            let linesize = (line.title as NSString).sizeWithAttributes(textFontAttributes)
            w = max(w, linesize.width)
        }
        return CGSizeMake(COLORPADDING + w + 2 * PADDING, h + 2 * PADDING)
    }
}

public func CGContextAddRoundedRect(c: CGContextRef, rect: CGRect, var radius: CGFloat) {
    if (2 * radius > rect.size.height) {
        radius = rect.size.height / 2.0
    }
    if (2 * radius > rect.size.width) {
        radius = rect.size.width / 2.0
    }
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, CGFloat(M_PI), CGFloat(M_PI * 1.5), 0)
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, CGFloat(M_PI * 1.5), CGFloat(M_PI * 2), 0)
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, CGFloat(M_PI * 2), CGFloat(M_PI * 0.5), 0)
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, CGFloat(M_PI * 0.5), CGFloat(M_PI), 0)
    CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius)
}

public func CGContextFillRoundedRect(c: CGContextRef, rect: CGRect, radius: CGFloat) {
    CGContextBeginPath(c)
    CGContextAddRoundedRect(c, rect: rect, radius: radius)
    CGContextFillPath(c)
}