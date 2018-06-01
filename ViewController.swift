//
//  ViewController.swift
//  DDGDiceAnimation
//
//  Created by dudongge on 2018/5/30.
//  Copyright © 2018年 dudongge. All rights reserved.
//
import UIKit
import AudioToolbox

class ViewController: UIViewController {
    //骰子动画
    var diceAnimationView: CPK3DiceAnimationView?
    //正在进行色子动画
    var isDiceMoving: Bool = false
    //控制台信息
    var diceShowLabel = UILabel()
    var typeTitle = ["和值","三同号","二同号","三不同号","二不同号"]
    var typePlays: [DiceAnimationType] = [.hzType,.same3Type,.same2Type,.diff3Type,.diff2Type]
    var diceCount = 3
    var typePlay: DiceAnimationType = .hzType
    var diceTitle = "和值"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 19/255.0, green: 144/255.0, blue: 81/255.0, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.text = "晃动手机摇骰子"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 10, y: 50, width: self.view.frame.size.width - 20, height: 40)
        self.view.addSubview(titleLabel)
        
        diceShowLabel.text = "打印骰子信息"
        diceShowLabel.textColor = UIColor.black
        diceShowLabel.textAlignment = .center
        diceShowLabel.numberOfLines = 0
        diceShowLabel.frame = CGRect(x: 10, y: self.view.center.y - 200, width: self.view.frame.size.width - 20, height: 100)
        self.view.addSubview(diceShowLabel)
        diceShowLabel.backgroundColor = UIColor.clear
        
        let typeLabel = UILabel()
        typeLabel.text = "选择投注类型"
        typeLabel.textColor = UIColor.white
        typeLabel.textAlignment = .left
        typeLabel.frame = CGRect(x: 10, y: self.view.center.y - 50, width: self.view.frame.size.width - 20, height: 40)
        self.view.addSubview(typeLabel)
        
        let typeBtnWidth = ScreenWidth / 5.0
        for i in 0..<5 {
            let btn = UIButton()
            btn.tag = 100 + i
            btn.frame = CGRect(x: typeBtnWidth * CGFloat(i), y: self.view.center.y, width: typeBtnWidth, height: 40)
            btn.setTitle(typeTitle[i], for: UIControlState())
            if i == 0 {
                btn.backgroundColor = UIColor.red
            } else {
                btn.backgroundColor = UIColor.white
            }
            btn.setTitleColor(UIColor.black, for: UIControlState())
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.black.cgColor
            btn.addTarget(self, action: #selector(self.changeType(btn:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        
        let diceCount = UILabel()
        diceCount.text = "选择骰子个数"
        diceCount.textColor = UIColor.white
        diceCount.textAlignment = .left
        diceCount.frame = CGRect(x: 10, y: self.view.center.y + 50, width: self.view.frame.size.width - 20, height: 40)
        self.view.addSubview(diceCount)
        
        let diceBtnWidth = ScreenWidth / 3.0
        for i in 0..<3 {
            let btn = UIButton()
            btn.tag = 200 + i
            btn.frame = CGRect(x: diceBtnWidth * CGFloat(i), y: self.view.center.y + 100, width: diceBtnWidth, height: 40)
            btn.setTitle(String(i + 1) + "个", for: UIControlState())
            if i == 2 {
                btn.backgroundColor = UIColor.red
            } else {
                btn.backgroundColor = UIColor.white
            }
            btn.setTitleColor(UIColor.black, for: UIControlState())
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.black.cgColor
            btn.addTarget(self, action: #selector(self.changeDiceCount(btn:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
        
        let startBtn = UIButton()
        startBtn.frame = CGRect(x: 10, y: self.view.center.y + 150, width: ScreenWidth - 20, height: 40)
        startBtn.setTitle("摇一摇", for: UIControlState())
        startBtn.setTitleColor(UIColor.black, for: UIControlState())
        startBtn.layer.borderWidth = 1.0
        startBtn.layer.borderColor = UIColor.black.cgColor
        startBtn.addTarget(self, action: #selector(self.shakeDice), for: .touchUpInside)
        self.view.addSubview(startBtn)
        
        self.initDiceAnimationView()
    }
    //返回色子动画类型和色子数
    func getDiceAnimationCount() -> Int {
        return self.diceCount
    }
    //返回筛子动画类型
    func getDiceAnimationType() -> DiceAnimationType {
        return self.typePlay
    }
    //色子动画开始
    func diceAnimationStart(){
        self.diceShowLabel.backgroundColor = UIColor.clear
        diceAnimationView?.isHidden = false
        self.view.isUserInteractionEnabled = false
        self.isDiceMoving = true
        diceAnimationView?.startAnimation()
    }
    
    //色子动画结束
    func diceAnimationStop(_ diceArr:[Int]) {
        var message = ""
        if diceArr.count == 1 {
            message = " 骰子1: " + String(diceArr[0])
        } else if  diceArr.count == 2 {
            message = " 骰子1: " + String(diceArr[0]) + "  骰子2: " + String(diceArr[1])
        } else if  diceArr.count == 3 {
            message = " 骰子1: " + String(diceArr[0]) + "  骰子2: " + String(diceArr[1]) + "  骰子3: "  + String (diceArr[2])
        }
        self.diceShowLabel.text = "玩法" + self.diceTitle + ":" + message
        self.diceShowLabel.backgroundColor = UIColor.white
        diceAnimationChangeFrame()
    }
    
    func diceAnimationChangeFrame(){
        weak var ws = self
        UIView.animate(withDuration: 1.0, animations: {
            ws!.diceAnimationView?.alpha = 0.0
        }, completion: { (true) in
            ws!.diceAnimationView?.isHidden = true
            ws!.diceAnimationView?.alpha = 1.0
            ws!.isDiceMoving = false
        })
    }
    
    func diceAnimationDisappear() {
        diceAnimationView?.imageDong1.frame = CGRect(x:self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        diceAnimationView?.imageDong2.frame = CGRect(x:self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        diceAnimationView?.imageDong3.frame = CGRect(x:self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        
    }
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if isDiceMoving == false {
                 self.diceAnimationStart()
            }
        }
    }
    
    //按钮的点击事件
    //改变类型
    @objc func changeType(btn: UIButton) {
        self.dismissDiceAnimationView()
        for btn in self.view.subviews {
            if btn.tag == 100 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 101 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 102 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 103 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 104 {
                btn.backgroundColor = UIColor.white
            }
        }
        if btn.tag == 100 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 101 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 102 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 103 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 104 {
            btn.backgroundColor = UIColor.red
        }
        self.typePlay = self.typePlays[btn.tag - 100]
        self.diceTitle = self.typeTitle[btn.tag - 100]
        self.initDiceAnimationView()
    }
    //改变骰子个数
    @objc func changeDiceCount(btn: UIButton) {
        self.dismissDiceAnimationView()
        for btn in self.view.subviews {
            if btn.tag == 200 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 201 {
                btn.backgroundColor = UIColor.white
            } else if btn.tag == 202 {
                btn.backgroundColor = UIColor.white
            }
        }
        if btn.tag == 200 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 201 {
            btn.backgroundColor = UIColor.red
        } else if btn.tag == 202 {
            btn.backgroundColor = UIColor.red
        }
        self.diceCount = btn.tag - 200 + 1
        self.initDiceAnimationView()
    }
    @objc func shakeDice() {
        self.diceAnimationStart()
    }
    func initDiceAnimationView() {
        if self.diceAnimationView == nil {
            self.diceAnimationView = CPK3DiceAnimationView(diceCount: getDiceAnimationCount(), diceAnimationType: getDiceAnimationType(),animations:1.0)
            self.view.addSubview(diceAnimationView!)
            weak var ws = self
            self.diceAnimationView?.diceFinishBlock = { (finish,diceArr) -> Void in
                if finish == true {
                    ws!.view.isUserInteractionEnabled = true
                    ws!.diceAnimationStop(diceArr)
                }
            }
        }
    }
    func dismissDiceAnimationView() {
        if self.diceAnimationView != nil {
            self.diceAnimationView?.removeFromSuperview()
            self.diceAnimationView = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

