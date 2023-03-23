//
//  LoadingView.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

enum RotationDirection {
    case clockwise, counterClockwise
}

protocol Animatable {
    func start()
    func stop()
}

class LoadingView: BaseCustomView, Animatable {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bigCircle: UIView!
    @IBOutlet weak var smallCircle: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLoadingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLoadingView()
    }
    
    private func setLoadingView() {
        bigCircle.fullRound()
        bigCircle.drawCircleView(arcCenter: CGPoint(x: bigCircle.bounds.width / 2, y: bigCircle.bounds.width / 2),
                                 radius: 30,
                                 startAngle: deg2rad(45),
                                 endAngle: deg2rad(135),
                                 clockwise: true,
                                 color: UIColor.black.cgColor)
        
        smallCircle.drawCircleView(arcCenter: CGPoint(x: smallCircle.bounds.width / 2, y: smallCircle.bounds.width / 2),
                                   radius: 17,
                                   startAngle: deg2rad(45),
                                   endAngle: deg2rad(270),
                                   clockwise: false,
                                   color: UIColor.white.cgColor)
    }
    
    func start() {
        bigCircle.rotation(start: true, duration: 1, direction: .clockwise)
        smallCircle.rotation(start: true, duration: 2, direction: .counterClockwise)
    }
    
    func stop() {
        bigCircle.rotation(start: false, duration: 2, direction: .clockwise)
        smallCircle.rotation(start: false, duration: 1, direction: .counterClockwise)
    }
}
