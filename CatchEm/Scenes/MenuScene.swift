//
//  MenuScene.swift
//  CatchEm
//
//  Created by Mark Tiddy on 26/08/2019.
//  Copyright © 2019 Mark Tiddy. All rights reserved.
//


//Info for AdMob

//App Id
// ca-app-pub-8080686117362027~4567164341

//Intitial
//  ca-app-pub-8080686117362027/1279845397


//Sample int Ad
// ca-app-pub-3940256099942544/4411468910

import SpriteKit

class MenuScene: SKScene {
    
    var animateList = SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.wait(forDuration: 1.0),SKAction.fadeOut(withDuration: 1.0)])
    
    var logoAnimation = SKAction.sequence([SKAction.rotate(byAngle: 360.0, duration: 120.0)])
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 22/255, green: 45/255, blue: 59/255, alpha: 1.0)
        addLogo()
        addLabels()
    }

    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "circle")
       logo.size = CGSize(width: frame.width/2, height: frame.width/2)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/3.5)
        logo.run(SKAction.repeatForever(logoAnimation))
        addChild(logo)
    }
    
    func addLabels() {
        
        let gameTitle = SKLabelNode(text: "Catch 'Em")
        gameTitle.fontName = "Montserrat-Black"
        gameTitle.fontSize = frame.size.width / 10
        gameTitle.fontColor = UIColor.white
        gameTitle.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameTitle)
        
        let playLabel = SKLabelNode(text: "Tap to Start!")
        playLabel.fontName = "Montserrat-Black"
        playLabel.fontSize = frame.size.width / 9
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - playLabel.frame.size.height*4.5)
        playLabel.run(SKAction.repeatForever(animateList))
        addChild(playLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: " + "\(UserDefaults.standard.integer(forKey: "HighScore"))")
        highScoreLabel.fontName = "Montserrat-Black"
        highScoreLabel.fontColor = UIColor(red: 136/255, green: 200/255, blue: 43/255, alpha: 1.0)
        highScoreLabel.fontSize = frame.size.width / 15
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height*4)
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Last Score: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "Montserrat-Black"
        recentScoreLabel.fontColor = UIColor(red: 63/255, green: 167/255, blue: 214/255, alpha: 1.0)
        recentScoreLabel.fontSize = frame.size.width / 15
         recentScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - recentScoreLabel.frame.size.height*3)
        addChild(recentScoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        let settingScene = SettingScene(size: view!.bounds.size)
        view!.presentScene(settingScene)
        
        
       
        
    }
    
}
