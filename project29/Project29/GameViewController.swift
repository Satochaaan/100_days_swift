//
//  GameViewController.swift
//  Project29
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
	var currentGame: GameScene!

	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!

	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!

	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerNumber: UILabel!

    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    
    @IBOutlet var currentWindLabel: UILabel!
    
    var scorePlayer1 = 0 {
        didSet {
            player1ScoreLabel.text = String(scorePlayer1)
        }
    }
    
    var scorePlayer2 = 0 {
        didSet {
            player2ScoreLabel.text = String(scorePlayer2)
        }
    }
    
    var currentWindName = "" {
        didSet {
            currentWindLabel.text = currentWindName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

		angleChanged(angleSlider)
		velocityChanged(velocitySlider)
        
        scorePlayer1 = 0
        scorePlayer2 = 0
        currentWindName = ""

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)

				currentGame = scene as? GameScene
				currentGame.viewController = self
                currentWindName = currentGame.currentWind.getName()
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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

	@IBAction func angleChanged(_ sender: AnyObject) {
		angleLabel.text = "Angle: \(Int(angleSlider.value))°"
	}

	@IBAction func velocityChanged(_ sender: AnyObject) {
		velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
	}

	@IBAction func launch(_ sender: AnyObject) {
		angleSlider.isHidden = true
		angleLabel.isHidden = true

		velocitySlider.isHidden = true
		velocityLabel.isHidden = true

		launchButton.isHidden = true

		currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
	}

	func activatePlayer(number: Int) {
		if number == 1 {
			playerNumber.text = "<<< PLAYER ONE"
		} else {
			playerNumber.text = "PLAYER TWO >>>"
		}

		angleSlider.isHidden = false
		angleLabel.isHidden = false

		velocitySlider.isHidden = false
		velocityLabel.isHidden = false

		launchButton.isHidden = false
	}
    
    func finishGame() {
        if scorePlayer1 < scorePlayer2 {
            playerNumber.text = "PLAYER TWO WIN!!!"
        } else {
            playerNumber.text = "PLAYER ONE WIN!!!"
        }
    }
}
