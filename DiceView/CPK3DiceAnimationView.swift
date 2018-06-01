//
//  CPK3DiceAnimation.swift
//  
//  色子动画view的封装
//  Created by dudg on 2017/1/22.
//  Copyright © 2017年 CP. All rights reserved.
//

import UIKit
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
//色子动画类型
enum DiceAnimationType {
    //和值
    case hzType
    //三同号
    case same3Type
    //二同号
    case same2Type
    //三不同号
    case diff3Type
    //二不同号
    case diff2Type
}

class CPK3DiceAnimationView: UIView ,CAAnimationDelegate{
    //骰子个数
    var diceCount: Int!
    //是否移动
    var isMove: Bool!
    //动画类型
    var diceAnimationType:DiceAnimationType = .hzType
    //动画持续时间
    var animations: Double = 0.0
    //基础
    var image1: UIImageView!
    var image2: UIImageView!
    var image3: UIImageView!
    
    //动画
    var imageDong1: UIImageView!
    var imageDong2: UIImageView!
    var imageDong3: UIImageView!
    var diceFinishBlock: (_ finish:Bool,_ diceArr: [Int]) ->Void = {_,_  in }
    
    convenience init(diceCount:Int,diceAnimationType:DiceAnimationType,animations: Double) {
        self.init(frame: CGRect.zero)
        self.diceCount = diceCount
        self.animations = animations
        self.diceAnimationType = diceAnimationType
        self.setupUI()
        self.setupConstraints()
    }
    func setupUI() {
        image1 = UIImageView()
        image1.image = UIImage(named:"1.png")
        image2 = UIImageView()
        image2.image = UIImage(named:"2.png")
        image3 = UIImageView()
        image3.image = UIImage(named:"3.png")
        
        imageDong1 = UIImageView()
        imageDong2 = UIImageView()
        imageDong3 = UIImageView()
    }
    
    func setupConstraints(){
        
    }
    
    func startAnimation(){
        image1.isHidden = true;
        image2.isHidden = true;
        image3.isHidden = true;
        
        imageDong1.isHidden = true;
        imageDong2.isHidden = true;
        imageDong3.isHidden = true;
       
        if diceCount == 1 {
            dice1Animation()
        } else if diceCount == 2{
            dice1Animation()
            dice2Animation()
        } else {
            dice1Animation()
            dice2Animation()
            dice3Animation()
        }
    }
    
    //骰子1的动画
    func dice1Animation(){
        //******************旋转动画的初始化******************
        //******************旋转动画******************
        //******************动画组合******************
        //转动骰子的载入
        let myImages:[UIImage] = [UIImage(named:"7.png")!,UIImage(named:"8.png")!,UIImage(named:"9.png")!]
        //骰子1的转动图片切换
        let imageDong11 = UIImageView(frame: CGRect(x: 85.0, y: 115.0, width: 90.0,height: 90.0))
        imageDong11.animationDuration = 0.1
        imageDong11.animationImages = myImages
        imageDong11.startAnimating()
        self.addSubview(imageDong11)
        imageDong1 = imageDong11

        //******************位置变化******************
        
        //骰子1的位置变化
        let dice1Point = self.getRandomNumbers(8, lenth: UInt32(ScreenWidth))
        let p1 = CGPoint(x: CGFloat(dice1Point[0]), y: CGFloat(dice1Point[1]))
        let p2 = CGPoint(x: CGFloat(dice1Point[2]), y: CGFloat(dice1Point[3]))
        let p3 = CGPoint(x: CGFloat(dice1Point[4]), y: CGFloat(dice1Point[5]))
        let p4 = CGPoint(x: CGFloat(dice1Point[6]), y: CGFloat(dice1Point[7]))
        let keypoint = [NSValue(cgPoint: p1),NSValue(cgPoint: p2),NSValue(cgPoint: p3),NSValue(cgPoint: p4)]
        let animation1 = CAKeyframeAnimation(keyPath: "position")
        animation1.values = keypoint
        animation1.duration = animations
        imageDong11.layer.position = CGPoint(x: ScreenWidth / 2  - 60, y: ScreenHeight / 2.0 - 50)
        //骰子1的动画组合
        let animGroup1 = CAAnimationGroup()
        animGroup1.animations = [animation1]
        animGroup1.duration = animations;
        animGroup1.delegate = self
        imageDong11.layer.add(animGroup1, forKey: "position")
    }
    func dice2Animation(){
        //转动骰子的载入
        let myImages:[UIImage] = [UIImage(named:"7.png")!,UIImage(named:"8.png")!,UIImage(named:"9.png")!]
        //骰子2的转动图片切换
        let imageDong12 = UIImageView(frame: CGRect(x: 135.0, y: 115.0, width: 90.0,height: 90.0))
        imageDong12.animationDuration = 0.1
        imageDong12.animationImages = myImages
        imageDong12.startAnimating()
        self.addSubview(imageDong12)
        imageDong2 = imageDong12
        
        
        //骰子2的位置变化
        let dice2Point = self.getRandomNumbers(8, lenth: UInt32(ScreenWidth))
        let p21 = CGPoint(x: CGFloat(dice2Point[0]), y: CGFloat(dice2Point[1]))
        let p22 = CGPoint(x: CGFloat(dice2Point[2]), y: CGFloat(dice2Point[3]))
        let p23 = CGPoint(x: CGFloat(dice2Point[4]), y: CGFloat(dice2Point[5]))
        let p24 = CGPoint(x: CGFloat(dice2Point[6]), y: CGFloat(dice2Point[7]))
        
        let keypoint2 = [NSValue(cgPoint: p21),NSValue(cgPoint: p22),NSValue(cgPoint: p23),NSValue(cgPoint: p24)]
        let animation2 = CAKeyframeAnimation(keyPath: "position")
        animation2.values = keypoint2
        animation2.duration = animations
        imageDong12.layer.position = CGPoint(x: ScreenWidth / 2 + 60  , y: ScreenHeight / 2.0 - 100)
        //骰子2的动画组合
        let animGroup2 = CAAnimationGroup()
        animGroup2.animations = [animation2]
        animGroup2.duration = animations;
        imageDong12.layer.add(animGroup2, forKey: "position")

    }
    
    func dice3Animation(){
        //转动骰子的载入
        let myImages:[UIImage] = [UIImage(named:"7.png")!,UIImage(named:"8.png")!,UIImage(named:"9.png")!]
        //骰子3的转动图片切换
        let imageDong13 = UIImageView(frame: CGRect(x: 195.0, y: 115.0, width: 90.0,height: 90.0))
        imageDong13.animationDuration = 0.1
        imageDong13.animationImages = myImages
        imageDong13.startAnimating()
        self.addSubview(imageDong13)
        imageDong3 = imageDong13
      
        //骰子3的位置变化
        let dice3Point = self.getRandomNumbers(8, lenth: UInt32(ScreenWidth))
        let p31 = CGPoint(x: CGFloat(dice3Point[0]), y: CGFloat(dice3Point[1]))
        let p32 = CGPoint(x: CGFloat(dice3Point[2]), y: CGFloat(dice3Point[3]))
        let p33 = CGPoint(x: CGFloat(dice3Point[4]), y: CGFloat(dice3Point[5]))
        let p34 = CGPoint(x: CGFloat(dice3Point[6]), y: CGFloat(dice3Point[7]))
        let keypoint3 = [NSValue(cgPoint: p31),NSValue(cgPoint: p32),NSValue(cgPoint: p33),NSValue(cgPoint: p34)]
        let animation3 = CAKeyframeAnimation(keyPath: "position")
        animation3.values = keypoint3
        animation3.duration = animations
        imageDong13.layer.position = CGPoint(x: ScreenWidth / 2 + 60, y: ScreenHeight / 2.0 + 30)
        //骰子3的动画组合
        let animGroup3 = CAAnimationGroup()
        animGroup3.animations = [animation3]
        animGroup3.duration = animations;
        imageDong13.layer.add(animGroup3, forKey: "position")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        image1.isHidden = true
        image2.isHidden = true
        image3.isHidden = true
        
        imageDong1.stopAnimating()
        imageDong2.stopAnimating()
        imageDong3.stopAnimating()
        
        //产生随机数
        switch self.diceAnimationType {
        case .hzType:
            //色子1
            let dice1 = Int(arc4random_uniform(6)) + 1
            imageDong1.image = UIImage(named: "\(dice1).png")
            //色2
            let dice2 = Int(arc4random_uniform(6)) + 1
            imageDong2.image = UIImage(named: "\(dice2).png")
            //色3
            let dice3 = Int(arc4random_uniform(6)) + 1
            imageDong3.image = UIImage(named: "\(dice3).png")
            self.animationStop(true, diceArr: [dice1,dice2,dice3])
        case .diff2Type:
            let diff2Arr = self.getRandomNumbers(2,lenth: 5)
            //色子1
            imageDong1.image = UIImage(named: "\(diff2Arr[0]).png")
            //色2
            imageDong2.image = UIImage(named: "\(diff2Arr[1]).png")
            //色3
            let dice3 = Int(arc4random_uniform(6))
            imageDong3.image = UIImage(named: "\(dice3).png")
            self.animationStop(true, diceArr: diff2Arr)
        case .diff3Type:
            //从1到4
            let diff3Arr0 = self.getRandomNumbers(1,lenth: 4)[0]
            //从2到5
            var diff3Arr1 = self.getRandomNumbers(1,lenth: 4)[0]
            //从3到6
            var diff3arr2 = self.getRandomNumbers(1,lenth: 4)[0]
            if diff3Arr0 == 1 {
                diff3Arr1 = self.getRandomNumbers(1,lenth: 4)[0] + 1
                diff3arr2 = diff3arr2 + 2
                if diff3Arr1 >= diff3arr2 {
                    diff3arr2 = diff3Arr1 + 1
                }
            } else if diff3Arr0 == 2 {
                diff3Arr1 = self.getRandomNumbers(1, lenth: 3)[0] + 2
                diff3arr2 = self.getRandomNumbers(1, lenth: 3)[0] + 3
                if diff3Arr1 >= diff3arr2 {
                    diff3arr2 = diff3Arr1 + 1
                }
            } else if diff3Arr0 == 3 {
                diff3Arr1 = self.getRandomNumbers(1, lenth: 2)[0] + 3
                diff3arr2 = self.getRandomNumbers(1, lenth: 2)[0] + 4
                if diff3Arr1 >= diff3arr2 {
                    diff3arr2 = diff3Arr1 + 1
                }
            } else {
                diff3Arr1 = 5
                diff3arr2 = 6
            }
            //色子1
            imageDong1.image = UIImage(named: "\(diff3Arr0).png")
            //色2
            imageDong2.image = UIImage(named: "\(diff3Arr1 ).png")
            //色3
            imageDong3.image = UIImage(named: "\(diff3arr2 ).png")
            self.animationStop(true, diceArr:[diff3Arr0 ,diff3Arr1  ,diff3arr2 ])
        case .same2Type:
            let same2Arr = self.getRandomNumbers(2,lenth: 6)
            //色1
            imageDong1.image = UIImage(named: "\(same2Arr[0]).png")
            //色2
            imageDong2.image = UIImage(named: "\(same2Arr[0]).png")
            //色3
            imageDong3.image = UIImage(named: "\(same2Arr[1]).png")
            self.animationStop(true, diceArr: [same2Arr[0],same2Arr[0],same2Arr[1]])
        case .same3Type:
            let same3Arr = self.getRandomNumbers(1,lenth: 6)
            //色1
            imageDong1.image = UIImage(named: "\(same3Arr[0]).png")
            //色2
            imageDong2.image = UIImage(named: "\(same3Arr[0]).png")
            //色3
            imageDong3.image = UIImage(named: "\(same3Arr[0]).png")
            self.animationStop(true, diceArr: [same3Arr[0],same3Arr[0],same3Arr[0]])
        }
    }
    func animationStop(_ finish:Bool,diceArr: [Int]){
        self.diceFinishBlock(finish,diceArr)
    }
    //随机产生不同的号码
    func getRandomNumbers(_ count:Int,lenth:UInt32) -> [Int] {
        var randomNumbers = [Int]()
        for _ in 0...(count - 1) {
            var number = Int()
            number = Int(arc4random_uniform(lenth))+1
            while randomNumbers.contains(number) {
                number = Int(arc4random_uniform(lenth))+1
            }
            randomNumbers.append(number)
        }
        return randomNumbers
    }
}
