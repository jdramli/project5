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
        //Can this Section be shifted to a class file? This might help segregate out modifying bullet parameters and interactions
        self.bullet = SKShapeNode.init(circleOfRadius: 10)
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.addChild(bullet!)
    
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.bullet?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            n.fillColor = SKColor.green
            self.addChild(n)
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
