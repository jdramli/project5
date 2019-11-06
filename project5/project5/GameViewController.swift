//
//  GameViewController.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 10/30/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.showsPhysics = true // Added this to show physics body outlines
                }
            }
        }
    }
    @IBAction func unwindToGameViewController(segue: UIStoryboardSegue){
         //Nothing is needed here
         //These comments are just instructions on how to edit the "Main.storyboard" file after adding this function action to the code here.  Adding this function action makes seeing this possible when doing "control" click-and-drag to the "EXIT" button on the top of any viewcontroller in the storyboard
         //After this function is added, drage the segue from your button up to the little orange "EXIT" icon at the top right of your sourceview of the viewcontroller in the Main.storyboard, and you should see the option to "unwindTo[ViewControllerName]WithSegue" i.e. "unwindToStartViewControllerWithSegue"
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
