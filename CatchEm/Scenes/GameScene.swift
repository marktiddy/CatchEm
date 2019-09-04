//
//  GameScene.swift
//  CatchEm
//
//  Created by Mark Tiddy on 25/08/2019.
//  Copyright © 2019 Mark Tiddy. All rights reserved.
//


//Info for AdMob

//App Id
// ca-app-pub-8080686117362027~4567164341

//Intitial
//  ca-app-pub-8080686117362027/1279845397


//Sample int Ad
// ca-app-pub-3940256099942544/4411468910

//Banner Ad ID
//  ca-app-pub-8080686117362027/7937587237

//Test Banner Ad ID

// ca-app-pub-3940256099942544/2934735716

import SpriteKit
import GoogleMobileAds
import AVFoundation
import DeviceUtil


enum PlayColors {
    static let colors = [
         UIColor(red: 136/255, green: 200/255, blue: 43/255, alpha: 1.0), //LIME
         UIColor(red: 63/255, green: 167/255, blue: 214/255, alpha: 1.0), //BLUE
        UIColor(red: 238/255, green: 99/255, blue: 82/255, alpha: 1.0), //RED
        UIColor(red: 89/255, green: 205/255, blue: 144/255, alpha: 1.0) //GREEN
    ]
}

enum SwitchState: Int {
    case lime, blue, red, green
}

class GameScene: SKScene {
 
    
    //Property for wheel
    var colorWheel: SKSpriteNode!
    var colorWheel2: SKSpriteNode!
    var colorWheel3: SKSpriteNode!
    
    //Audio Player
    var player: AVAudioPlayer?
    
    //Color Switch Properties
    var wheel1State = SwitchState.lime
    var wheel2State = SwitchState.lime
    var wheel3State = SwitchState.lime
    var currentColorIndex: Int?
    var currentColorIndex2: Int?
    var currentColorIndex3: Int?
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    var lossCount = 0
    let hintLabel = SKLabelNode(text: "*Hint* Tap Wheels To Turn")
    var gravity = CGVector(dx: 0.0, dy: 0.4)
    let difficultyLevel = UserDefaults.standard.string(forKey: "difficultyLevel")
    var gameCount = UserDefaults.standard.integer(forKey: "gameCounter")
    var interstitial: GADInterstitial!
var adUnitID = "ca-app-pub-8080686117362027/1279845397"
    var isMuted : Bool = false
    var muteImageName = "unmute"
    let muteButton = SKSpriteNode(imageNamed: "mute")
    let unmuteButton = SKSpriteNode(imageNamed: "unmute")
    var screenSize = "small"
    var device = String(DeviceUtil().hardwareDescription().self)
    var ballsInPlay : Int = 1

    
    
    override func didMove(to view: SKView) {
        
        //Device utility
        detectScreen() //options are small or large
        
        //Set up stuff
        if screenSize == "large" {
            setupPhysics(easyVect: 0.6, normalVect: 0.8, hardVect: 1.2)
        } else if screenSize == "small" {
            setupPhysics(easyVect: 0.3, normalVect: 0.5, hardVect: 1.0)
        } else {
            setupPhysics(easyVect: 0.6, normalVect: 0.8, hardVect: 1.2)
        }


        layoutScene()
        
        //Set up advert
   createNewAd()
        
    }
    
    func setupPhysics(easyVect: Double, normalVect: Double, hardVect: Double) {

        if difficultyLevel == "easy" {
            gravity = CGVector(dx: 0.0, dy: easyVect) //0.5
            physicsWorld.gravity = gravity;
            physicsWorld.contactDelegate = self
            
        } else if difficultyLevel == "normal" {
            gravity = CGVector(dx: 0.0, dy: normalVect) //0.7
            physicsWorld.gravity = gravity;
            physicsWorld.contactDelegate = self
            
        } else if difficultyLevel == "hard" {
            gravity = CGVector(dx: 0.0, dy: hardVect) //1.1
            physicsWorld.gravity = gravity;
            physicsWorld.contactDelegate = self
            
        } else {
            physicsWorld.gravity = gravity;
            physicsWorld.contactDelegate = self
        }
        
    }
    
    func detectScreen() {
        //Update for new phones!
        if self.device.contains("Plus") {
           screenSize = "large"
        } else if device.contains("X") {
            screenSize = "large"
            print("iPhone X detected")
        } else if device.contains("XR") {
            screenSize = "large"
        } else if device.contains("XS") {
            screenSize = "large"
        } else {
            screenSize = "small"
        }
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 22/255, green: 45/255, blue: 59/255, alpha: 1.0)

        
        
        //Display first sorter
        colorWheel = SKSpriteNode(imageNamed: "circle")
        colorWheel.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        colorWheel.position = CGPoint(x: frame.midX / 3, y: frame.maxY - colorWheel.size.height)
        colorWheel.zPosition = ZPositions.wheels
        colorWheel.physicsBody = SKPhysicsBody(circleOfRadius: colorWheel.size.width/2)
        colorWheel.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorWheel.physicsBody?.isDynamic = false
        colorWheel.name = "colorWheel1"
        colorWheel.isUserInteractionEnabled = false
        
        //Add to scene by passing child
        addChild(colorWheel)
        
        //Display second sorter
        colorWheel2 = SKSpriteNode(imageNamed: "circle")
        colorWheel2.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        colorWheel2.position = CGPoint(x: frame.midX, y: frame.maxY - colorWheel2.size.height - 20)
        colorWheel2.zPosition = ZPositions.wheels
        colorWheel2.physicsBody = SKPhysicsBody(circleOfRadius: colorWheel2.size.width/2)
        colorWheel2.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory2
        colorWheel2.physicsBody?.isDynamic = false
        colorWheel2.name = "colorWheel2"
        colorWheel2.isUserInteractionEnabled = false
        
        //Add to scene by passing child
        addChild(colorWheel2)
        
        //Display third sorter
        colorWheel3 = SKSpriteNode(imageNamed: "circle")
        colorWheel3.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        colorWheel3.position = CGPoint(x: 5 * (frame.midX / 3), y: frame.maxY - colorWheel3.size.height)
        colorWheel3.physicsBody = SKPhysicsBody(circleOfRadius: colorWheel3.size.width/2)
        colorWheel3.zPosition = ZPositions.wheels
        colorWheel3.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory3
        colorWheel3.physicsBody?.isDynamic = false
        colorWheel3.name = "colorWheel3"
        colorWheel3.isUserInteractionEnabled = false
        
        //Add to scene by passing child
        addChild(colorWheel3)
        
        //Add the Score Board
        scoreLabel.fontName = "Montserrat-Black"
        scoreLabel.fontSize = 45.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
        
        //Hint Label
        hintLabel.fontName = "Montserrat-Black"
        hintLabel.fontSize = 20.0
        hintLabel.fontColor = UIColor.white
        hintLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        hintLabel.zPosition = ZPositions.label
        hintLabel.isHidden = true
        addChild(hintLabel)

        //Mute Labels
        muteButton.size = CGSize(width: frame.width/8.5, height: frame.width/8.5)
        muteButton.position = CGPoint(x: frame.maxX - 40, y: frame.minY + 80)
        muteButton.name = "muteButton"
        if UserDefaults.standard.bool(forKey: "isMuted") == false {
            //This means the app isn't muted. Mute button = volume
            muteButton.isHidden = false
        } else if UserDefaults.standard.bool(forKey: "isMuted") == true {
            //This means the user has previously muted and doesn't want volume
            muteButton.isHidden = true
        } else {
            //USer hasn't previously set so we enable sound
            muteButton.isHidden = false
        }
        addChild(muteButton)
        
        unmuteButton.size = CGSize(width: frame.width/8.5, height: frame.width/8.5)
        unmuteButton.position = CGPoint(x: frame.maxX - 40, y: frame.minY + 80)
        unmuteButton.name = "unmuteButton"
        if UserDefaults.standard.bool(forKey: "isMuted") == false {
            //User hasn't muted it
            unmuteButton.isHidden = true
        } else if UserDefaults.standard.bool(forKey: "isMuted") == true {
            //User has muted
            unmuteButton.isHidden = false
        } else {
            //User hasn't made a choice yet so we enable sound
            unmuteButton.isHidden = true
        }
        addChild(unmuteButton)
      
        //MARK: NEW CODE FOR 1 AT START
       // showBall2()
        //MARK: OLD CODE TO SHOW 3 AT THE START
        
        //Show the balls
        showBall2()

        let deadlineTime = DispatchTime.now() + .microseconds(250000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.showBall()
        }

        let deadlineTime2 = DispatchTime.now() + .microseconds(500000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime2) {
            self.showBall3()
        }
   
        
    }
    
    func showBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
       
        //create some random numbers
       // let rand1 = CGFloat(arc4random_uniform(9) * 10)
        
        //Ball 1
        let ball1 = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball1.colorBlendFactor = 1.0
        ball1.name = "Ball1"
        ball1.position = CGPoint(x: frame.midX / 3, y: frame.minY - 20)
        ball1.physicsBody = SKPhysicsBody(circleOfRadius: ball1.size.width/2)
        ball1.zPosition = ZPositions.balls
        ball1.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball1.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
      //  ball1.physicsBody?.contactTestBitMask = ball1.physicsBody?.collisionBitMask ?? 0
        ball1.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball1)
       
    
    }
    
    func showBall2() {
        currentColorIndex2 = Int(arc4random_uniform(UInt32(4)))
      //  let rand2 = CGFloat(arc4random_uniform(10) * 10)
        
        //Ball 2
        let ball2 = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex2!], size: CGSize(width: 30.0, height: 30.0))
        ball2.colorBlendFactor = 1.0
        ball2.name = "Ball2"
        ball2.size = CGSize(width: 30.0, height: 30.0)
        ball2.zPosition = ZPositions.balls
        ball2.position = CGPoint(x: frame.midX, y: frame.minY - 20)
        ball2.physicsBody = SKPhysicsBody(circleOfRadius: ball2.size.width/2)
        ball2.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory2
        ball2.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory2
        ball2.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball2)
    }
    
    func showBall3() {
        currentColorIndex3 = Int(arc4random_uniform(UInt32(4)))
        //let rand3 = CGFloat(arc4random_uniform(7) * 10)

        //Ball 3
        let ball3 = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex3!], size: CGSize(width: 30.0, height: 30.0))
        ball3.colorBlendFactor = 1.0
        ball3.name = "Ball3"
        ball3.size = CGSize(width: 30.0, height: 30.0)
        ball3.zPosition = ZPositions.balls
        ball3.position = CGPoint(x: 5 * (frame.midX / 3), y: frame.minY - 20)
        ball3.physicsBody = SKPhysicsBody(circleOfRadius: ball3.size.width/2)
        ball3.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory3
        ball3.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory3
        ball3.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball3)
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    //MARK:-- Turn Wheel Function
    func turnWheel(WheelID : String) {
        
        //First Wheel
        //wheel1State
        if WheelID == "colorWheel1" {
            //Do somehthing to first wheel
            if let newState = SwitchState(rawValue: wheel1State.rawValue + 1) {
                wheel1State = newState
            } else {
                wheel1State = .lime
            }
            
            colorWheel.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
            
        } else if WheelID == "colorWheel2" {
            //do something to the second wheel
            if let newState = SwitchState(rawValue: wheel2State.rawValue + 1) {
                wheel2State = newState
            } else {
                wheel2State = .lime
            }
            
            colorWheel2.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
            
        } else if WheelID == "colorWheel3" {
            //Do something to the third wheel
            if let newState = SwitchState(rawValue: wheel3State.rawValue + 1) {
                wheel3State = newState
            } else {
                wheel3State = .lime
            }
            
            colorWheel3.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
            
            
        }
        
    }
    
    
    
    //MARK: Game Over Function
    func gameOver() {
        if lossCount == 3 {
            UserDefaults.standard.set(score, forKey: "RecentScore")
            
            if score > UserDefaults.standard.integer(forKey: "HighScore") {
                
                UserDefaults.standard.set(score, forKey: "HighScore")
                
            }
            
            //Code to count how many games we've played so far
            gameCount = gameCount + 1
            UserDefaults.standard.set(gameCount, forKey: "gameCounter")
            
            //Display ad if this is user's 2nd game
            
            if UserDefaults.standard.integer(forKey: "gameCounter") == 2 {
           
                if UserDefaults.standard.bool(forKey: "isPurchased") == false {
                      showScreenAd()
               }
                UserDefaults.standard.set(0, forKey: "gameCounter")
            }
            
            //Go back to menu scene
            let menuScene = MenuScene(size: view!.bounds.size)
            view!.presentScene(menuScene)
        } else if lossCount == 1 {
            
            if screenSize == "small" {
                setupPhysics(easyVect: 0.8, normalVect: 1.0, hardVect: 1.2)

            } else if screenSize == "large" {
                setupPhysics(easyVect: 0.9, normalVect: 1.2, hardVect: 1.4)
            } else {
                setupPhysics(easyVect: 0.9, normalVect: 1.2, hardVect: 1.4)
            }
            
        } else if lossCount == 2 {
            // 1.7, 1.6, 1.2
    setupPhysics(easyVect: 1.6, normalVect: 2.0, hardVect: 2.2)
        }
    }
    
    //MARK: Audio function
    func muteFunction() {
       // if muteButton.isHidden == true {
            if UserDefaults.standard.bool(forKey: "isMuted") == true {
            muteButton.isHidden = false
            unmuteButton.isHidden = true
            isMuted = false
            UserDefaults.standard.set(false, forKey: "isMuted")
        } else {
            muteButton.isHidden = true
            unmuteButton.isHidden = false
            isMuted = true
            UserDefaults.standard.set(true, forKey: "isMuted")
        }
    }
    
    
    func playSound(soundName : String) {
        
//        if isMuted == false {
            if UserDefaults.standard.bool(forKey: "isMuted") == false {
            //play sound
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                /* iOS 10 and earlier require the following line:
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = player else { return }
                
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    
    }
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            
            if node.name == "colorWheel1" {
                turnWheel(WheelID: node.name!)
                hintLabel.isHidden = true
            } else if node.name == "colorWheel2" {
                turnWheel(WheelID: node.name!)
                hintLabel.isHidden = true
            } else if node.name == "colorWheel3" {
                turnWheel(WheelID: node.name!)
                hintLabel.isHidden = true
            } else if node.name == "muteButton" {
                muteFunction()
            } else if node.name == "unmuteButton" {
                muteFunction()
            } else {
                print("Doing nothing")
                hintLabel.isHidden = false
            }
        }
        
   
    
        
    }
    
    //MARK: Ad Code
    
    func showScreenAd() {
        
        if interstitial.isReady {
            let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
            self.interstitial.present(fromRootViewController: currentViewController)
            
        } else {
            print("Ad wasn't readt")
        }
        
        
    }
    
    func createNewAd() {
        interstitial = GADInterstitial(adUnitID: adUnitID)
        let request = GADRequest()
        interstitial.load(request)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
  
    func destroy(ball: SKNode) {
        //doing nothing yet
        ball.removeFromParent()
      
    }
    //MARK: Checking touches
    func didBegin(_ contact: SKPhysicsContact) {
       //Checking to see what happened
        
        if contact.bodyA.node?.name == "colorWheel1" {
            //See if the player is right
            if currentColorIndex == wheel1State.rawValue {
              destroy(ball: contact.bodyB.node!)
                playSound(soundName: "noise")
                showBall()
                score = score + 1
                updateScoreLabel()
            } else {
                lossCount = lossCount + 1
                gameOver()
            }
            
        } else if contact.bodyA.node?.name == "colorWheel2" {
            //See if the player is right
            if currentColorIndex2 == wheel2State.rawValue {
                destroy(ball: contact.bodyB.node!)
                playSound(soundName: "noise")
               
//                if ballsInPlay == 1 {
//                    //First ball sucess so add second
//                    showBall2()
//                    showBall()
//                    ballsInPlay = 2
//                } else {
//                    showBall2()
//                }
                showBall2()
                
               
                score = score + 1
                updateScoreLabel()
            } else {
                lossCount = lossCount + 1
                gameOver()
            }
            
            
        } else if contact.bodyA.node?.name == "colorWheel3" {
            //See if the player is right
            if currentColorIndex3 == wheel3State.rawValue {
                destroy(ball: contact.bodyB.node!)
                playSound(soundName: "noise")
                showBall3()
                score = score + 1
                updateScoreLabel()
            } else {
                lossCount = lossCount + 1
                gameOver()
            }
        }
  
    }
}

//To do

//Sort layout
//Add other gravity
//add other did begin contact methods

//Mark 2
//Add adverts

