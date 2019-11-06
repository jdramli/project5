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

//This enum type is to create a quick unique collision bitmask by increasing by power of 2.
enum CollisionType: UInt32{
    case player = 1
    case bullet = 2
    case enemy = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate { //Added SKPhysicsContactDelegate to make sure the physics contact functions can be written.
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    //variables added from default
    private var picbullet : SKSpriteNode? //Opted not to use this for now as of 11/3/19
    private var hero : SKShapeNode? //Opted not to use this for now as of 11/3/19
    
    private var bullet : SKShapeNode?
    private var upgrade : SKShapeNode? //creating a power_up node
    private var player : SKSpriteNode?
    private var enemy : SKSpriteNode?
    private var gameTimer: Timer? //Timer object to be called regularly
    private var count_label : SKLabelNode?
    private var kill_count = 0;
    
    private var powerup = 0
    
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
        //self.picbullet = self.childNode(withName: "//bullet") as? SKSpriteNode
        //Adding the option of a shape bullet or a sprite bullet by building both for now
        self.bullet = SKShapeNode.init(circleOfRadius: 10)
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.addChild(bullet!)
      
        
        
        self.player = self.childNode(withName: "//hero") as? SKSpriteNode
        self.enemy = self.childNode(withName: "//enemy") as? SKSpriteNode
        self.count_label = self.childNode(withName: "//count_label") as? SKLabelNode
        //let moveRect = SKAction.moveTo(x: 74.0, duration: 0) //This was just a test line
        //player!.run(moveRect) //This was just a test line
        
        //Set Physics bodies
        //player
        //self.player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 74, height: 97)) //This was a physics body of the player rectangle
        self.player?.physicsBody = SKPhysicsBody(texture: (player?.texture!)!, size: (player?.texture!.size())!) //This sets the physics body to the actual texture size and shape.
        self.player?.physicsBody?.affectedByGravity = false
        //enemy
        self.enemy?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 109, height: 82))
        self.enemy?.physicsBody?.affectedByGravity = false
        
        self.bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        //self.bullet?.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 100, height: 100))
        self.bullet?.physicsBody?.affectedByGravity = false
        self.bullet?.physicsBody?.mass = 20
        self.bullet?.position = CGPoint(x: 800, y: 300) //Moves initial bullet image offscreen out of play at 800x so that it doesn't interfere with gameplay.
        
        //self.enemy?.isHidden = true
        //self.enemy?.removeFromParent() // this creates a funny glitch where enemies spawn from the center.
        //MyNotes; Create a timer cycle to generate the enemy objects every few seconds
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        
        //MyNotes: Create physics interactions using the enum UInt32 bitmasks above
        player!.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        enemy!.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue

        player!.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
        enemy!.physicsBody?.collisionBitMask = CollisionType.bullet.rawValue | CollisionType.player.rawValue
        enemy!.physicsBody?.contactTestBitMask = CollisionType.bullet.rawValue
    
       
    }
    
    @objc func runTimedCode(){
        //create enemy nodes
        if let e = self.enemy?.copy() as! SKSpriteNode?{
            e.position = player!.anchorPoint
            self.addChild(e)
            let enemy_path = UIBezierPath()
            
            enemy_path.move(to: CGPoint(x: Double.random(in:-300...300), y: 590))
            //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
            enemy_path.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y-1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
            let move = SKAction.follow(enemy_path.cgPath, asOffset: true, orientToPath: true, speed: 200)
            let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
            e.run(sequence)
        }
        
        //create  upgrade power-up nodes
        if let u = self.upgrade?.copy() as! SKShapeNode?{
            
        }
        
    }
    
    //This function is necessary for physics contact body interactions.
    override func didMove(to view: SKView){
        physicsWorld.contactDelegate = self
    }
    func didBegin(_ contact: SKPhysicsContact){ //This function determines when contact happens
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        //This creates the contact nodes, but we don't know which nodes correspond to which contact yet, so the next lines are to sort the nodes and make sure they can be organized into a trackable way.
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" } //This just sorts them in alphabetical order by name i.e. bullet, enemy, player.
        
        //This setup makes it so that if there is ANY contact of the 3 contacts now, then "player" will be nodeB because it is last.  Bullet would be nodeA, and enemy could be either (node B if colliding with bullet and node A if colliding with player).
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if (secondNode.name == "enemy"){
            firstNode.removeFromParent()
            secondNode.removeFromParent()
            kill_count += 1
            count_label!.text = "Bugs Busted: " + String(kill_count)
        }
        
        
        
        
    }
    func touchDown(atPoint pos : CGPoint) {
        
        //MyNotes: First, move player, then create shot. The moveTo function proved to be a bit tricky/buggy, so I implemented the quick fix below of fixing the y position.
        player!.position = CGPoint(x: pos.x, y: -593) //Quick fix to make the player move just along the "x" axis of the touchDown pos by setting y to a fixed 593 and the x to the input of pos.x.
        
        //MyNotes: Next, make a copy of the bullet-sprite node for manipulation
        
        //if let n = self.picbullet?.copy() as! SKSpriteNode? {//uncomment this for picbullet
        if let n = self.bullet?.copy() as! SKShapeNode? { //uncomment this for shape bullet
              n.position = player!.anchorPoint //TODO: CRITICAL NOTE, MUST USE "anchorPoint" to generate proper player position when launching a sprite node from the player's "position"
              //n.position = CGPoint(x:-100, y: -100)
              //n.position = CGPoint(x: player!.position.x-30, y: player!.position.y+150)
              //CRITICAL DEBUGGING ISSUE ENCOUNTERED -- SETTING THIS POSITION TO 0,0 USES THE ORIGINAL SCREEN 0,0 WHICH IS THE MIDDLE.  HOWEVER, THE 0,0 OF AN SKSHAPENODE IS THE BOTTOM-LEFT CORNER OF THE SCREEN.  NEED TO FIND A WAY TO LINK THESE TWO TO THE SAME POINT OF REFERENCE!!!
              print(pos)
              print(player!.anchorPoint)//anchor point is (0.5,0.5).  This seems to be a basis point for where the player position is derived?

              n.strokeColor = SKColor.green
              n.fillColor = SKColor.green
              
              self.addChild(n)
              
              //MyNotes: Next, create a movement path for the bullet object from the player to offscreen
              //This section of code creates a path object and makes n move along the path
              let bulletpath = UIBezierPath()
              
               //bulletpath.move(to: player!.position) //makes player twist
             bulletpath.move(to: CGPoint( x: player!.position.x, y: player!.position.y + 50) ) // makes player not twist, by moving the start location.
              //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
              bulletpath.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y+1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
              let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
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
