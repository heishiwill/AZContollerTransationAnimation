//
//  ViewController.swift
//  AZContollerTransationAnimation
//
//  Created by wanghaohao on 2019/9/16.
//  Copyright © 2019 whao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var transDelegate:UIViewControllerTransitioningDelegate?
    
    private lazy var presentAnimatedTransitioning:AZPresentAnimatedTransitioning = {
        return AZPresentAnimatedTransitioning()
    } ()
    
    private lazy var dismissAnimatedTransitioning:AZDismissAnimatedTransitioning = {
        return AZDismissAnimatedTransitioning()
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
    }

    @IBAction func presentTapped1() {
        let controller = AZPresentController()
        transDelegate = AZViewControllerTransitioning(presentedViewController: controller)
        controller.transitioningDelegate = transDelegate
        self.navigationController?.present(controller, animated: true) {}
    }
    
    @IBAction func presentTapped2() {
        let controller = AZPresentController()
        let presentationController = AZBackgroundPresentationController(presentedViewController: controller, presenting: self)
        //虽然transitioningDelegate是weak的，
        //但是AZBackgroundPresentationController被加到uiwindow上了，所以没有被release
        controller.transitioningDelegate = presentationController
        presentationController.maskView.backgroundColor = .red
        presentationController.originFrameOfPresentedViewInContainerView = CGRect(x: 88, y: -300, width: 300, height: 300)
        presentationController.staticFrameOfPresentedViewInContainerView = CGRect(x: 88, y: 200, width: 300, height: 300)
        presentationController.dimissedFrameOfPresentedViewInContainerView = CGRect(x: 88, y: 800, width: 300, height: 300)
        presentationController.transitionAnimationClosure = { isPresent, fromViewController, toViewController in
            if isPresent {
                toViewController.view.frame = CGRect(x: 88, y: 200, width: 300, height: 300)
            } else {
                fromViewController.view.frame = CGRect(x: 0, y: 800, width: 300, height: 300)
            }
        }
        
        // AZBackgroundPresentationController默认转场动画外，可选择自定义设置转场动画
        presentationController.presentAnimatedTransitioning = self.presentAnimatedTransitioning
        //        presentationController.dismissAnimatedTransitioning = self.dismissAnimatedTransitioning
        self.navigationController?.present(controller, animated: true) {}
    }
    
    @IBAction func pushTapped() {
        
    }
}
