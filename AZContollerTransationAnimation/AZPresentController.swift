//
//  AZPresentController.swift
//  AZContollerTransationAnimation
//
//  Created by wanghaohao on 2019/9/16.
//  Copyright © 2019 whao. All rights reserved.
//

import UIKit

class AZPresentController: UIViewController {
    private lazy var intro:UILabel = {
        let label = UILabel()
        label.text = "this is presented controller"
        label.backgroundColor = .yellow
        return label
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        self.view.addSubview(intro)
        intro.frame = CGRect(x: 10, y: 200, width: 200, height: 30)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
