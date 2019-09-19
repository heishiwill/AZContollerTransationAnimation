//
//  ViewController.swift
//  AZContollerTransationAnimation
//
//  Created by wanghaohao on 2019/9/16.
//  Copyright © 2019 whao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
    }

    @IBAction func presentTapped() {
        let controller = AZPresentController()
        let presentationController = AZBackgroundPresentationController(presentedViewController: controller, presenting: self)
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
        
        self.navigationController?.present(controller, animated: true) {
            
        }
    }
    
    @IBAction func pushTapped() {
        
    }
}

