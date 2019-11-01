//
//  GameScene.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 10/30/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    //variables added from default
    private var bullet : SKShapeNode?
    private var hero : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        //Can this Section be shifted to a class file? This might help segregate out modifying hero parameters and interactions
        self.hero = SKShapeNode.init(rect: (CGRect(x: frame.minX+100, y:frame.minY+100, width: 70, height: 20)))
        self.hero?.strokeColor = SKColor.yellow
        self.hero?.fillColor = SKColor.yellow
        self.addChild(hero!)
        hero!.position = CGPoint(x:100, y: 100)
        //Can this Section be shifted to a class file? This might help segregate out modifying bullet parameters and interactions
        self.bullet = SKShapeNode.init(circleOfRadius: 10)
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.addChild(bullet!)
        
        
        //make a path for the white circle to move
        
        
    
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.bullet?.copy() as! SKShapeNode? {
            //n.position = pos
            //n.position = CGPoint(x:-100, y: -100)
            n.position = CGPoint(x: hero!.position.x, y: hero!.position.y)
            //CRITICAL DEBUGGING ISSUE ENCOUNTERED -- SETTING THIS POSITION TO 0,0 USES THE ORIGINAL SCREEN 0,0 WHICH IS THE MIDDLE.  HOWEVER, THE 0,0 OF AN SKSHAPENODE IS THE BOTTOM-LEFT CORNER OF THE SCREEN.  NEED TO FIND A WAY TO LINK THESE TWO TO THE SAME POINT OF REFERENCE!!!
            
            n.strokeColor = SKColor.green
            n.fillColor = SKColor.green
            self.addChild(n)
            
            hero?.position = CGPoint(x:0,y:0) //IN SPRITEKIT, THE 0,0 POSITION IS THE BOTTOM LEFT CORNER OF THE SCREEN, NOT THE MIDDLE
            
            //hero?.position = CGPoint(x:Double.random(in:-100...100), y:Double.random(in:-100...100))
            
            //This section of code creates a path object and makes n move along the path
            let path = UIBezierPath()
            
            //print("hero position x: ", hero!.position.x, "and y: ", hero!.position.y)
            path.move(to: CGPoint(x:hero!.position.x,y:hero!.position.y))
            path.addLine(to: CGPoint(x:0,y:200))
            let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
            n.run(move)
        }
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
