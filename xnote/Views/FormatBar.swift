//
//  FormatBar.swift
//  Alnote
//
//  Created by ilya bolotov on 28.09.2021.
//  Copyright © 2021 enjelhutasoit. All rights reserved.
//

import UIKit

class FormatBar: UIView {
    
    @IBOutlet var formatBar: UIView!
    @IBOutlet weak var bold: UIButton!
    @IBOutlet weak var italic: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FormatBar", owner: self, options: nil)
        //formatBar.fixInView(self)
        let screen = UIScreen.main.bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        formatBar.frame = self.bounds
        formatBar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(formatBar)
        
        
//        formatBar.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(formatBar)
//        formatBar.edges(to: cardView, useMargins: true)
    }
    
    
}

//extension UIView
//{
//    func fixInView(_ container: UIView!) -> Void{
//        self.translatesAutoresizingMaskIntoConstraints = false;
//        self.frame = container.frame;
//        container.addSubview(self);
//        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//
//
//    }
//}

extension UIView {

    func makeEdges(to view: UIView, useMargins: Bool = false) -> [NSLayoutConstraint] {
        return [
            (useMargins ? layoutMarginsGuide.leftAnchor : leftAnchor).constraint(equalTo: view.leftAnchor),
            (useMargins ? layoutMarginsGuide.rightAnchor : rightAnchor).constraint(equalTo: view.rightAnchor),
            (useMargins ? layoutMarginsGuide.topAnchor : topAnchor).constraint(equalTo: view.topAnchor),
            (useMargins ? layoutMarginsGuide.bottomAnchor : bottomAnchor).constraint(equalTo: view.bottomAnchor)
        ]
    }

    func edges(to view: UIView, useMargins: Bool = false) {
        NSLayoutConstraint.activate(makeEdges(to: view, useMargins: useMargins))
    }
}
