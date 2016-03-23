//
//  ZECustomKeyBoard.swift
//  ZECustomKeyboard
//
//  Created by 胡春源 on 16/3/22.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit


protocol ZECustomTextViewDelegate{
    func sendAction(text:String)
}

class ZECustomTextView: UIView {
    // 记录一大波默认参数 用于计算
    private let buttonW:CGFloat = 57
    private let textViewX:CGFloat = 1
    private let textViewY:CGFloat = 1
    private var textViewH:CGFloat = 30
    private var textViewRect:CGRect!
    private var textViewW:CGFloat = 0
    private let buttonTitle = "确认"
    private var selfFrame:CGRect!
    private var selfDefultHight:CGFloat!
    private var isShowing:Bool = false
    
    // 控件
    private var backgroundView:UIView! // textView背景View
    var textView:UITextView!// 输入框
    var sendButton:UIButton!// 确认按钮
    var delegate:ZECustomTextViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 记录默认属性
        isShowing = false
        selfDefultHight = frame.size.height
        textViewW = UIScreen.mainScreen().bounds.size.width - buttonW - 30
        self.backgroundColor = UIColor.init(colorLiteralRed: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        textViewRect = CGRectMake(textViewX, textViewY, textViewW, textViewH)
        selfFrame = self.frame
        // 创建输入框
        textView = UITextView(frame: textViewRect)
        textView.textColor = UIColor.lightGrayColor()
        // 创建背景View
        self.backgroundView = UIView(frame: CGRectMake(10,10,textViewW+2,32))
        backgroundView.backgroundColor = UIColor.init(colorLiteralRed: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        self.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        
        // 创建按钮
        sendButton = UIButton(type: UIButtonType.System)
        sendButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        sendButton.frame = CGRectMake(CGRectGetMaxX(backgroundView.frame)+8, 10, buttonW, 30)
        sendButton.backgroundColor = UIColor.init(colorLiteralRed: 0/255.0, green: 127/255.0, blue: 255/255.0, alpha: 1)
        sendButton.tintColor = UIColor.whiteColor()
        sendButton.addTarget(self, action: Selector("sendAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(sendButton)
        
        // 切圆角
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 5;
        
        // 注册通知
        registNotification()
    }
    // 将要出现
    func keyboardWillShow(notification:NSNotification){
        isShowing = true
        // 通知传参
        let userInfo  = notification.userInfo
        // 取出键盘bounds
        let  keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        // 时间
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // 动画模式
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        // 偏移量
        let deltaY = keyBoardBounds.size.height
        // 动画
        let animations:(() -> Void) = {
            self.transform = CGAffineTransformMakeTranslation(0,-deltaY)
            self.textView.text = ""
            self.textView.textColor = UIColor.blackColor()
        }
        // 判断是否需要动画
        if duration > 0 {
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
    }
    
    // 将要收起
    func keyboardWillHid(notification:NSNotification){
        isShowing = false
        let userInfo  = notification.userInfo
     
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.transform = CGAffineTransformIdentity
            self.frame = self.selfFrame
            self.textView.frame = self.textViewRect
            self.backgroundView.frame = CGRectMake(10,10,self.textViewW+2,32)
           
            self.textView.textColor = UIColor.lightGrayColor()
            
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    // 将要改变
    func keyboardWillChange(notification:NSNotification){
        let contentSize = self.textView.contentSize
        if contentSize.height > 140{
            return;
        }
        var selfframe = self.frame
        // selfHight的计算我也不太清楚 等大神解答..
        var selfHeight = (self.textView.superview?.frame.origin.y)! * 2 + contentSize.height
        if selfHeight <= selfDefultHight {
            selfHeight = selfDefultHight
        }
        let selfOriginY = selfframe.origin.y - (selfHeight - selfframe.size.height)
        selfframe.origin.y  = selfOriginY;
        selfframe.size.height = selfHeight;
        self.frame = selfframe;
        self.textView.frame = CGRectMake(1, 1, textViewW, selfHeight-20);
        self.backgroundView.frame = CGRectMake(10, 10, textViewW+2, selfHeight-18);
    }
    
    func sendAction(){
        if (isShowing){
            if self.textView.text.characters.count == 0 {
                print("评论为空")
            }else{
                self.textView.resignFirstResponder()
                delegate?.sendAction(self.textView.text)
                self.textView.text = "我有话说"
            }
        }else{
            self.textView.becomeFirstResponder()
        }
    }
    
    // 注册通知
    func registNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHid:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChange:"), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
