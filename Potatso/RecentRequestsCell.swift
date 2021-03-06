//
//  RecentRequestsCell.swift
//  Potatso
//
//  Created by LEI on 4/17/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation
import Cartography
import PotatsoModel

extension RuleAction {
    
    var image: UIImage? {
        switch self {
        case .Proxy:
            return "Proxy".image
        case .Reject:
            return "Reject".image
        case .Direct:
            return "Direct".image
        }
    }
    
}

class PaddingLabel: UILabel {
    
    var padding: UIEdgeInsets = UIEdgeInsetsZero
    
    override func drawTextInRect(rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawTextInRect(newRect)
    }
    
    override func intrinsicContentSize() -> CGSize {
        var s = super.intrinsicContentSize()
        s.height += padding.top + padding.bottom
        s.width += padding.left + padding.right
        return s
    }
    
}

class RecentRequestsCell: UITableViewCell {
    
    static let dateformatter: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "hh:mm:ss"
        return f
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(methodLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(actionImageView)
        contentView.addSubview(httpVersionLabel)
        contentView.addSubview(statusLabel)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(request: Request) {
        methodLabel.text = request.method.description
        urlLabel.text = request.url
        urlLabel.numberOfLines = 2
        if let e = request.events.first {
            timeLabel.text = RecentRequestsCell.dateformatter.stringFromDate(NSDate(timeIntervalSince1970: e.timestamp))
        }else {
            timeLabel.text = nil
        }
        if let rule = request.rule {
            actionImageView.image = rule.action.image
        }else {
            if (request.globalMode) {
                actionImageView.image = "Proxy".image
            }else {
                actionImageView.image = "Direct".image
            }
        }
        if let version = request.version {
            httpVersionLabel.text = version
            httpVersionLabel.hidden = false
        }else {
            httpVersionLabel.hidden = true
        }
        if let code = request.responseCode {
            statusLabel.text = "\(code.rawValue)"
            statusLabel.textColor = code.color
            statusLabel.layer.borderColor = code.color.CGColor
            statusLabel.hidden = false
        }else {
            statusLabel.hidden = true
        }
    }
    
    func setupLayout() {
        timeLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        timeLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        constrain(contentView, self) { contentView, superview in
            contentView.edges == superview.edges
        }
        constrain(methodLabel, urlLabel, timeLabel, contentView) { methodLabel, urlLabel, timeLabel, contentView in
            methodLabel.width == 45
            methodLabel.leading == contentView.leading + 12
            methodLabel.top == contentView.top + 15
            
            timeLabel.trailing == contentView.trailing - 12
            timeLabel.centerY == methodLabel.centerY
            
            urlLabel.top == methodLabel.top - 2
            urlLabel.leading == methodLabel.trailing + 10
            urlLabel.trailing == timeLabel.leading - 10
            
            contentView.height >= 65
        }
        constrain(actionImageView, methodLabel) { actionImageView, methodLabel in
            actionImageView.centerX == methodLabel.centerX
            actionImageView.width == 15
            actionImageView.height == 15
            actionImageView.top == methodLabel.bottom + 12
        }
        constrain(httpVersionLabel, urlLabel, contentView) { httpVersionLabel, urlLabel, contentView in
            httpVersionLabel.leading == urlLabel.leading
            httpVersionLabel.top == urlLabel.bottom + 12
            httpVersionLabel.bottom == contentView.bottom - 16
        }
        constrain(httpVersionLabel, statusLabel) { httpVersionLabel, statusLabel in
            align(centerY: httpVersionLabel, statusLabel)
            statusLabel.leading == httpVersionLabel.trailing + 8
        }
    }
    
    lazy var methodLabel: UILabel = {
        let v = UILabel()
        v.textColor = "3498DB".color
        v.font = UIFont.systemFontOfSize(12)
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        v.textAlignment = .Center
        return v
    }()
    
    lazy var urlLabel: UILabel = {
        let v = UILabel(frame: CGRect.zero)
        v.textColor = "404040".color
        v.font = UIFont.systemFontOfSize(14)
        v.numberOfLines = 2
        v.lineBreakMode = .ByTruncatingTail
        return v
    }()
    
    lazy var timeLabel: UILabel = {
        let v = UILabel()
        v.textColor = "808080".color
        v.font = UIFont.systemFontOfSize(10)
        return v
    }()
    
    lazy var httpVersionLabel: PaddingLabel = {
        let v = PaddingLabel()
        v.textColor = "34495E".color
        v.font = UIFont.systemFontOfSize(10)
        v.layer.cornerRadius = 2
        v.layer.borderWidth = 0.5
        v.layer.borderColor = "34495E".color.CGColor
        v.padding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return v
    }()
    
    lazy var statusLabel: PaddingLabel = {
        let v = PaddingLabel()
        v.textColor = "34495E".color
        v.font = UIFont.systemFontOfSize(10)
        v.layer.cornerRadius = 2
        v.layer.borderWidth = 0.5
        v.layer.borderColor = "34495E".color.CGColor
        v.padding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return v
    }()
    
    lazy var actionImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .ScaleAspectFit
        return v
    }()
    
}