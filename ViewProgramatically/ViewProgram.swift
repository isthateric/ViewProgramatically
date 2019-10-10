//
//  AppDelegate.swift
//  ViewProgramatically
//
//  Created by Eric Fuentes on 1/15/19.
//  Copyright © 2019 Eric Fuentes. All rights reserved.
//
import Foundation
import UIKit
import MediaPlayer
import AVKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let rootVC = ViewController()
        rootVC.view.backgroundColor = UIColor(red: 0.6902, green: 0.8235, blue: 0.8863, alpha: 1)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        rootVC.view.frame = (window?.frame)!
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
class MyView: UIView{
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.alpha = 1
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        
        
    }
    
    
}

// mark View Controller
class ViewController: UIViewController, AVPlayerViewControllerDelegate, UIScrollViewDelegate {
    
   
    
    var myView = MyView(frame: CGRect(x: 49, y: 207, width: 276, height: 184))
    
    var secondView : MyView!
    //var secondView = MyView(frame: CGRect(x: 315, y: 750, width: 50, height: 50))
    
    
    var myImageView = UIImageView(frame: CGRect(x: 145, y: 25, width: 100, height: 100))
    var secondImage = UIImageView(frame: CGRect(x: -12, y: 150, width: 400, height: 400))
    var player: AVPlayer?
    var smallVideoPlayerViewController = AVPlayerViewController()
    var playerLayer: AVPlayerLayer?
    var videos: [String] = ["video1","video2","video3","video4","video5"]
    var currentVideo = 0
    var firstField : UITextField!
    var middleField : UITextField!
    var thirdField : UITextField!
    var Label: UILabel!
    var pinchGesture  = UIPinchGestureRecognizer()
    var rotateGesture  = UIRotationGestureRecognizer()
    var lastRotation   = CGFloat()
    
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchedView))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(pinchGesture)
        
        
        firstField = UITextField(frame: CGRect(x: 10, y: 650, width: 60, height: 40))
        firstField.backgroundColor = .white
        firstField.borderStyle = .line
        self.view.addSubview(firstField)
        
//        let middleField = UITextField(frame: CGRect(x: 85, y: 650, width: 50, height: 40))
//        middleField.backgroundColor = .white
//        middleField.borderStyle = .line
//        self.view.addSubview(middleField)
        
        thirdField = UITextField(frame: CGRect(x: 120, y: 650, width: 60, height: 40))
        thirdField.backgroundColor = .white
        thirdField.borderStyle = .line
        self.view.addSubview(thirdField)
        
        Label = UILabel(frame: CGRect(x: 150, y: 600, width: 100, height: 15 ))
        Label.text = "Sum"
        self.view.addSubview(Label)
        
        self.view.addSubview(myView)
        
        secondView = MyView(frame: CGRect(x: viewWidth-60, y: viewHeight-60, width: 50, height: 50))
        
        
        self.view.addSubview(secondView)
        
        self.createSegmentControl()
        self.createImageView()
        //self.createButton()
        self.secondImageView()
        self.clearVid()
        self.secondView.isHidden = false
        self.calculateButton()
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        myView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        myView.addGestureRecognizer(swipeLeft)
        
        let myFileManager = FileManager.default
        let mainBundle = Bundle.main
        let resourcesPath = mainBundle.resourcePath!
        guard let allItemsInTheBundle = try? myFileManager.contentsOfDirectory(atPath: resourcesPath) else {
            return
        }
        
        
        let videoPath = Bundle.main.path(forResource: videos[currentVideo], ofType: "mp4")
        let videoUrl = URL(fileURLWithPath: videoPath!)
        
        smallVideoPlayerViewController.showsPlaybackControls = true
        
        smallVideoPlayerViewController.player = AVPlayer(url: videoUrl)
        
        myView.addSubview(smallVideoPlayerViewController.view)
        
        smallVideoPlayerViewController.view.frame = myView.bounds
        
        smallVideoPlayerViewController.player?.play()
        
        
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        viewWidth = size.width
        viewHeight = size.height
//        secondView.frame =  CGRect(x: viewWidth-60, y: viewHeight-60, width: 50, height: 50)
//        //myImageView.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
//       // secondView = MyView(frame: CGRect(x: viewWidth-60, y: viewHeight-60, width: 50, height: 50))
//       // self.view.addSubview(secondView)
////        print(self.view.subviews.count)
//        secondImage.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
//        myView.center =  CGPoint(x: viewWidth/2, y: viewHeight/3)
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            //secondView = MyView(frame: CGRect(x: viewWidth-60, y: viewHeight-60, width: 50, height: 50))
            //secondView.frame =  CGRect(x: viewWidth/0, y: viewHeight/12, width: 50, height: 50)
            // secondView.frame =  CGRect(x: 0, y: 0, width: 50, height: 50)
            //myImageView = UIImageView(frame: CGRect(x: viewWidth-900, y: viewHeight-10, width: 100, height: 100))
           // myView = MyView(frame: CGRect(x: viewWidth-10, y: viewHeight/12, width: 800, height: 184))
            secondView.frame =  CGRect(x: viewWidth-60, y: viewHeight-60, width: 50, height: 50)
            secondImage.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
            myView.center =  CGPoint(x: viewWidth/2, y: viewHeight/3)
            Label.frame = CGRect(x: viewWidth-60, y: viewHeight/40, width: 50, height: 50)
            firstField.frame = CGRect(x: viewWidth-60, y: viewHeight/50, width: 100, height: 15)
            thirdField.frame = CGRect(x: viewWidth-60, y: viewHeight/30, width: 100, height: 15)
        } else {
            print("Portrait")
            secondImage.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
            myView.center =  CGPoint(x: viewWidth/2, y: viewHeight/2.24)
            Label.frame = CGRect(x: viewWidth/2, y: viewHeight-90, width: 100, height: 15)
            firstField.frame = CGRect(x: viewWidth/2, y: viewHeight-160, width: 60, height: 40)
            thirdField.frame = CGRect(x: viewWidth/7, y: viewHeight-160, width: 60, height: 40)


        }
    }
  
    
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubviewToFront(myImageView)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    @objc func calculateButtonTapped(sender: Any){

        Label.text = String(Int(firstField.text!)! + Int(thirdField.text!)!)


    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createSegmentControl()  {
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 108, y: 550, width: 150, height: 32))
        segmentedControl.backgroundColor = .white
        segmentedControl.insertSegment(withTitle: "ON", at: 4, animated: true)
        segmentedControl.insertSegment(withTitle: "OFF", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: UIControl.Event.valueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    @objc func handleSegmentChange(sender:UISegmentedControl)  {
        if sender.selectedSegmentIndex == 1 {
            smallVideoPlayerViewController.player?.isMuted = true
            myView.isHidden = true
            print ("off")
        }else{
            myView.isHidden = false
            smallVideoPlayerViewController.player?.isMuted = false

            print("on")
        }
    }
    
    @objc func handlePan(sender:UIPanGestureRecognizer)
    {
        sender.view?.center = sender.location(in: sender.view?.superview)
    }
    
    @objc func handleButtonTap(sender:Any){
        UIView.animate(withDuration: 0.25, animations: {
            self.myImageView.transform = self.myImageView.transform.rotated(by: CGFloat(M_PI_2))
        })
    }
    
    
    @objc func rotatedView(_ sender : UIRotationGestureRecognizer){
        
//        var lastRotation = CGFloat()
        
        self.view.bringSubviewToFront(myImageView)
        if(sender.state == UIGestureRecognizer.State.ended){
            lastRotation = 0.0;
        }
        let rotation = 0.0 - (lastRotation - sender.rotation)
        // var point = rotateGesture.location(in: viewRotate)
        let currentTrans = sender.view?.transform
        let newTrans = currentTrans!.rotated(by: rotation)
        sender.view?.transform = newTrans
        lastRotation =  sender.rotation
    }

    
    
    func createImageView() {
        self.myImageView.image = UIImage(named: "OKicon")
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
         let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotatedView(_:)))
        self.myImageView.addGestureRecognizer(rotateGesture)
        self.myImageView.isUserInteractionEnabled = true
        self.myImageView.isMultipleTouchEnabled = true
        self.myImageView.addGestureRecognizer(panGesture)
        self.myImageView.isUserInteractionEnabled = true
        self.view.insertSubview(self.myImageView, at: 0)
    }
    func secondImageView() {
        self.secondImage.image = UIImage(named: "wooden tv")
        self.view.insertSubview(self.secondImage, at: 0)
    }
    
//    func createButton() {
//        let button = UIButton(frame: CGRect(x: self.view.bounds.size.width/3, y: 700, width: 60, height: 25))
//
//        button.setTitle("Rotate", for: UIControl.State.normal)
//        button.backgroundColor = .blue
//        button.addTarget(self, action: #selector(handleButtonTap), for: UIControl.Event.touchUpInside)
//        self.view.addSubview(button)
//
//    }
    func calculateButton() {
        let button = UIButton(frame: CGRect(x: 230, y: 650, width: 100, height: 40))
        
        button.setTitle("Calculate", for: UIControl.State.normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(calculateButtonTapped), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
        
    }
    
    
    func clearVid(){
        if let player = self.player{
            player.pause()
            self.player = nil
            
        }
        if let layer = self.playerLayer{
            layer.removeFromSuperlayer()
            self.playerLayer = nil
        }
        
        self.myView.layer.sublayers?.removeAll()
    }
    
   
   
   
    func respondToGesture(gesture: UIGestureRecognizer) -> Void {
        
        if let pinch = gesture as? UIPinchGestureRecognizer {
            
            if let img = pinch.view as? UIImageView {
                
                img.transform = CGAffineTransform(scaleX: pinch.scale, y: pinch.scale)
                
                if pinch.state == .ended
                {
                    img.transform = CGAffineTransform(scaleX: (1 / pinch.scale), y: (1 / pinch.scale))
                }
            }
        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentVideo == videos.count - 1 {
                    currentVideo = 0
                    
                }else{
                    currentVideo += 1
                }
                print("swipe")
            case UISwipeGestureRecognizer.Direction.right:
                if currentVideo == 0 {
                    currentVideo = videos.count - 1
                }else{
                    currentVideo -= 1
                }
                print("swipe2")
            default:
                break
            }
            
            let videoPath = Bundle.main.path(forResource: videos[currentVideo], ofType: "mp4")
            let videoUrl = URL(fileURLWithPath: videoPath!)
            
             smallVideoPlayerViewController.player?.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
            
        }
    }

}



    
    

