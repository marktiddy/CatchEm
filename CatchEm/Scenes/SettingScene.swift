//
//  SettingScene.swift
//  CatchEm
//
//  Created by Mark Tiddy on 28/08/2019.
//  Copyright © 2019 Mark Tiddy. All rights reserved.
//

import SpriteKit

class SettingScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 22/255, green: 45/255, blue: 59/255, alpha: 1.0)
        addOptions()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
           
            if node.name == "easy" {
              UserDefaults.standard.set("easy", forKey: "difficultyLevel")
                startGame()
                
            } else if node.name == "normal" {
                UserDefaults.standard.set("normal", forKey: "difficultyLevel")
                startGame()
            } else if node.name == "hard" {
                UserDefaults.standard.set("hard", forKey: "difficultyLevel")
                startGame()
            } else {
                //do nothing
            }
        
        }
        
    }
    
        func addOptions() {
            //This is where we'll add options
            
            //Difficulty Level
            
            
           //Add the logo
                let logo = SKSpriteNode(imageNamed: "circle")
                logo.size = CGSize(width: frame.width/2, height: frame.width/2)
                logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/3.5)
                addChild(logo)
        
                //Add title
                let sceneTitle = SKLabelNode(text: "Choose Difficulty Level")
                sceneTitle.fontName = "Montserrat-Black"
                sceneTitle.fontSize = frame.size.width / 13 - 2
     //font size formally 22
                sceneTitle.fontColor = UIColor.white
                sceneTitle.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(sceneTitle)
            
            //Add difficulty label
            
            
            let easyLabel = SKLabelNode(text: "Easy")
            easyLabel.fontName = "Montserrat-Black"
            easyLabel.fontColor = UIColor(red: 136/255, green: 200/255, blue: 43/255, alpha: 1.0)
            easyLabel.fontSize = frame.size.width / 13
            easyLabel.position = CGPoint(x: frame.midX, y: frame.midY - easyLabel.frame.size.height*2)
            easyLabel.name = "easy"
            addChild(easyLabel)
            
            let normLabel = SKLabelNode(text: "Normal")
            normLabel.fontName = "Montserrat-Black"
            normLabel.fontColor = UIColor(red: 63/255, green: 167/255, blue: 214/255, alpha: 1.0)
            normLabel.fontSize = frame.size.width / 13
            normLabel.position = CGPoint(x: frame.midX, y: frame.midY - normLabel.frame.size.height*4.5)
            normLabel.name = "normal"
            addChild(normLabel)
            
            let hardLabel = SKLabelNode(text: "Hard")
            hardLabel.fontName = "Montserrat-Black"
            hardLabel.fontColor = UIColor(red: 238/255, green: 99/255, blue: 82/255, alpha: 1.0)
            hardLabel.fontSize = frame.size.width / 13
            hardLabel.position = CGPoint(x: frame.midX, y: frame.midY - hardLabel.frame.size.height*7.0)
            hardLabel.name = "hard"
            addChild(hardLabel)
            

            
        }
    
    func startGame() {
                let gameScene = GameScene(size: view!.bounds.size)
                view!.presentScene(gameScene)
    }
    
}
