//
//  AZBackgroundPresentationController.swift
//  AZContollerTransationAnimation
//
//  Created by wanghaohao on 2019/9/16.
//  Copyright © 2019 whao. All rights reserved.
//

import UIKit

class AZBackgroundPresentationController: UIPresentationController {
    /// 是否允许点击蒙层dismiss controller
    var clickMaskViewDismiss:Bool = true
    /// 动画时长
    var animationDuration:TimeInterval = 0.3
    /// presented view 开始的frame
    lazy var originFrameOfPresentedViewInContainerView:CGRect = {
        return self.containerView?.bounds ?? .zero
    } ()
    /// presented view 推出动画完成后的frame
    lazy var staticFrameOfPresentedViewInContainerView:CGRect = {
        return self.containerView?.bounds ?? .zero
    } ()
    /// presented view dismiss后的frame
    lazy var dimissedFrameOfPresentedViewInContainerView:CGRect = {
        var rect = self.frameOfPresentedViewInContainerView
        rect.origin.y = self.containerView?.bounds.size.height ?? 0
        return rect
    } ()
    /// present\dismiss 动画内容闭包
    var transitionAnimationClosure:((_ isPresenting:Bool, _ fromViewController:UIViewController, _ toViewController:UIViewController)-> Void)?
    /// 半透明蒙层
    lazy var maskView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isOpaque = false
        view.alpha = 0.0
        
        let panguesture = UITapGestureRecognizer(target: self, action: #selector(maskViewTapped(tapGuesture:)))
        panguesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(panguesture)
        view.isUserInteractionEnabled = true
        return view
    } ()
    
    deinit {
        printX("\(self) deinit!!!")
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = .custom
    }
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(maskView)
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (transitionCoordinatorContext) in
            self.maskView.alpha = 0.4
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (transitionCoordinatorContext) in
            self.maskView.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            maskView.removeFromSuperview()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return container.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        /**
         当animation为false时候，起作用。
         当animation为true的时候，
         */
        return self.staticFrameOfPresentedViewInContainerView
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        maskView.frame = self.containerView?.bounds ?? .zero
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === self.presentedViewController {
            self.containerView?.setNeedsLayout()
        }
    }
    
    @objc private func maskViewTapped(tapGuesture:UITapGestureRecognizer) {
        if clickMaskViewDismiss {
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
}

/**
 动画细节
 */
extension AZBackgroundPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated == true ? animationDuration : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        let containerView = transitionContext.containerView
        if toView != nil {
            containerView.addSubview(toView!)
            toView!.frame = self.originFrameOfPresentedViewInContainerView
        }
        let isPresenting:Bool = fromViewController == self.presentingViewController
        let duration = self.transitionDuration(using: transitionContext)
        if fromViewController == nil || toViewController == nil {return}
        
        UIView.animate(withDuration: duration, animations: {
            if self.transitionAnimationClosure == nil {
                if isPresenting {
                    toView?.frame = self.frameOfPresentedViewInContainerView
                } else {
                    fromView?.frame = self.dimissedFrameOfPresentedViewInContainerView
                }
            } else {
                self.transitionAnimationClosure?(isPresenting, fromViewController!, toViewController!)
            }
        }) { (finish) in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
    }
}

extension AZBackgroundPresentationController:UIViewControllerTransitioningDelegate {
    /**
     告诉控制器负责动画的类(UIPresentationController)
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    /**
     返回动画具体实现对象
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    /**
     返回动画具体实现对象
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension AZBackgroundPresentationController {
    func printX<T>(_ message: T,
                   file: String = #file,
                   method: String = #function,
                   line: Int = #line) {
        #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}

/**
 实现自定义过渡动画。
 1、继承UIPresentationController。
    UIPresentationController 的子类是负责「被呈现」及「负责呈现」的 controller 以外的内容。
    如带透明度的背景。
 2、实现UIViewControllerTransitioningDelegate代理。
    UIViewControllerAnimatedTransitioning 类将会负责「被呈现」的 ViewController 的过渡动画。
 */
