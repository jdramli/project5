//
//  GameScene.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 10/30/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import CoreGraphics
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    //variables added from default
    private var picbullet : SKSpriteNode?
    private var bullet : SKShapeNode?
    private var hero : SKShapeNode?
    private var player : SKSpriteNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        //Can this Section be shifted to a class file? This might help segregate out modifying hero parameters and interactions
        /*
        //This section of code is broken, I think because of improperly moving a CGRect via setting the position to a CGPoint.  I think it should be somethine instead like: "let moveRect = SKAction.moveTo(x:100, y:100)"; hero.runAction(moveRect)
        self.hero = SKShapeNode.init(rect: (CGRect(x: frame.minX+100, y:frame.minY+100, width: 70, height: 20)))
        self.hero?.strokeColor = SKColor.yellow
        self.hero?.fillColor = SKColor.yellow
        self.addChild(hero!)
        hero!.position = CGPoint(x:100, y: 100)
         */
        
        //Can this Section be shifted to a class file? This might help segregate out modifying bullet parameters and interactions
        self.picbullet = self.childNode(withName: "//bullet") as? SKSpriteNode
        //Adding the option of a shape bullet or a sprite bullet by building both for now
        self.bullet = SKShapeNode.init(circleOfRadius: 10)
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.addChild(bullet!)
      
        
        
        self.player = self.childNode(withName: "//hero") as? SKSpriteNode
        let moveRect = SKAction.moveTo(x: 74.0, duration: 0)
        player!.run(moveRect)
        
        //make a path for the white circle to move
        
        
    
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        //First, move player, then create shot. I will use the click to create a moveTo function here for the player and the bullet.  Perhaps other mechanics can be explored for moving the player later, but for now I will make do with this since it is a mobile game.
        player!.position = pos
        
        //if let n = self.picbullet?.copy() as! SKSpriteNode? {//uncomment this for picbullet
        if let n = self.bullet?.copy() as! SKShapeNode? { //uncomment this for shape bullet
                   n.position = player!.anchorPoint //TODO: CRITICAL NOTE, MUST USE "anchorPoint" to generate proper player position when launching a sprite node from the player's "position"
                  //n.position = CGPoint(x:-100, y: -100)
                  //n.position = CGPoint(x: player!.position.x-30, y: player!.position.y+150)
                  //CRITICAL DEBUGGING ISSUE ENCOUNTERED -- SETTING THIS POSITION TO 0,0 USES THE ORIGINAL SCREEN 0,0 WHICH IS THE MIDDLE.  HOWEVER, THE 0,0 OF AN SKSHAPENODE IS THE BOTTOM-LEFT CORNER OF THE SCREEN.  NEED TO FIND A WAY TO LINK THESE TWO TO THE SAME POINT OF REFERENCE!!!
                  print(player!.position.x,player!.position.y)
                  print(n.position.x,n.position.y)
                  print(player!.size)
                  print(player!.centerRect)
                  n.strokeColor = SKColor.green
                  n.fillColor = SKColor.green
                  
                  self.addChild(n)
                  
                  //hero?.position = CGPoint(x:0,y:0) //IN SPRITEKIT, THE 0,0 POSITION IS THE BOTTOM LEFT CORNER OF THE SCREEN, NOT THE MIDDLE
                  
                  //hero?.position = CGPoint(x:Double.random(in:-100...100), y:Double.random(in:-100...100))
                  
                  //This section of code creates a path object and makes n move along the path
                  let bulletpath = UIBezierPath()
                  //path.move(to: CGPoint(x:hero!.position.x,y:hero!.position.y))
                  //bulletpath.move(to: CGPoint(x:player!.position.x,y:player!.position.y))
                   bulletpath.move(to: player!.position)
                  //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
                  bulletpath.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y+1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                  let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 200)
                  let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                  n.run(sequence)
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
