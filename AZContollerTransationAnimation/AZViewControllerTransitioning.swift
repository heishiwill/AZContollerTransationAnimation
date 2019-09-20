//
//  AZViewControllerTransitioning.swift
//  AZContollerTransationAnimation
//
//  Created by wanghaohao on 2019/9/20.
//  Copyright © 2019 whao. All rights reserved.
//

import UIKit

class AZViewControllerTransitioning: NSObject, UIViewControllerTransitioningDelegate {
    
    init(presentedViewController:UIViewController) {
        super.init()
        presentedViewController.modalPresentationStyle = .custom
    }
    
    /**
     告诉控制器负责动画的类(UIPresentationController)
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AZBackgroundPresentationController(presentedViewController: presented, presenting: presenting)
    }
    /**
     返回动画具体实现对象
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AZPresentAnimatedTransitioning()
    }
    /**
     返回动画具体实现对象
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AZDismissAnimatedTransitioning()
    }
}

/**
 present转场动画实现动画细节
 */
class AZPresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    /// 动画时长
    private var animationDuration:TimeInterval = 0.3
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated == true ? animationDuration : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        if toView != nil {
            containerView.addSubview(toView!)
        }
        let duration = self.transitionDuration(using: transitionContext)
        toView!.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: duration, animations: {
            toView!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (finish) in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
    }
}

/**
 dismiss转场动画实现动画细节
 */
class AZDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    /// 动画时长
    var animationDuration:TimeInterval = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated == true ? animationDuration : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let duration = self.transitionDuration(using: transitionContext)
        fromView!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: duration, animations: {
            fromView!.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (finish) in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
    }
}
