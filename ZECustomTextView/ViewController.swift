//
//  ViewController.swift
//  ZECustomTextView
//
//  Created by 胡春源 on 16/3/22.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZECustomTextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let zeTextView = ZECustomTextView(frame: CGRectMake(0,UIScreen.mainScreen().bounds.height-50,UIScreen.mainScreen().bounds.width,50))
        zeTextView.delegate = self
        self.view.addSubview(zeTextView)
    }
    func sendAction(text: String) {
        print(text)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

