//
//  GameScene.swift
//  Project26
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
	case player = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
	var lastTouchPosition: CGPoint?
    var nowLevel: Int!

    var motionManager: CMMotionManager!

    var isGameOver = false
	var scoreLabel: SKLabelNode!
    
    var teleportTPosition: CGPoint!
    var teleportWPosition: CGPoint!
    var teleportEnable = true

	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)

		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		addChild(scoreLabel)

		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self

        nowLevel = 1
		loadLevel()
		createPlayer()

		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
    }

	func loadLevel() {
		let levelLines = loadLevelLines()
        guard !levelLines.isEmpty else { return }
        
        createLevelNode(lines: levelLines)
	}
    
    func loadLevelLines() -> [String] {
        var lines = [String]()
        
        if let levelPath = Bundle.main.path(forResource: "level\(String(nowLevel))", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath) {
                lines = levelString.components(separatedBy: "\n")
            }
        }
        
        return lines
    }
    
    func createLevelNode(lines: [String]) {
        // reversedして下から組み立て
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

                if letter == "x" {
                    // load wall
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position

                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                } else if letter == "v"  {
                    // load vortex
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = "vortex"
                    node.position = position
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false

                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    addChild(node)
                } else if letter == "s"  {
                    // load star
                    let node = SKSpriteNode(imageNamed: "star")
                    node.name = "star"
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false

                    node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    addChild(node)
                } else if letter == "t" {
                    // load teleport
                    let node = SKSpriteNode(color: .purple, size: CGSize(width: 64, height: 64))
                    node.name = "teleportT"
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.isDynamic = false

                    node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    teleportTPosition = position
                    addChild(node)
                } else if letter == "w" {
                    // load teleport
                    let node = SKSpriteNode(color: .purple, size: CGSize(width: 64, height: 64))
                    node.name = "teleportW"
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.isDynamic = false

                    node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    teleportWPosition = position
                    addChild(node)
                } else if letter == "f"  {
                    // load finish
                    let node = SKSpriteNode(imageNamed: "finish")
                    node.name = "finish"
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false

                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    addChild(node)
                }
            }
        }
    }

	func createPlayer() {
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 96, y: 672)
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody?.allowsRotation = false
		player.physicsBody?.linearDamping = 0.5

		player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
		player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
		addChild(player)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: self)
			lastTouchPosition = location
		}
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: self)
			lastTouchPosition = location
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchPosition = nil
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchPosition = nil
	}

	override func update(_ currentTime: TimeInterval) {
		guard isGameOver == false else { return }
		#if targetEnvironment(simulator)
			if let currentTouch = lastTouchPosition {
				let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
				physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
			}
		#else
			if let accelerometerData = motionManager.accelerometerData {
				physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
			}
		#endif
	}

	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.node == player {
			playerCollided(with: contact.bodyB.node!)
		} else if contact.bodyB.node == player {
			playerCollided(with: contact.bodyA.node!)
		}
	}

	func playerCollided(with node: SKNode) {
		if node.name == "vortex" {
			player.physicsBody?.isDynamic = false
			isGameOver = true
			score -= 1

			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(to: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])

			player.run(sequence) { [unowned self] in
				self.createPlayer()
				self.isGameOver = false
			}
            
		} else if node.name == "star" {
			node.removeFromParent()
			score += 1
            
        } else if node.name == "teleportT" {
            guard teleportEnable else { return }
            
            player.physicsBody?.isDynamic = false
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([remove])
            
            player.run(sequence) { [unowned self] in
                self.player.position = teleportWPosition
                self.player.physicsBody?.isDynamic = true
                self.teleportEnable = false
                self.teleportTimerStart()
                self.addChild(self.player)
            }
            
        } else if node.name == "teleportW" {
            guard teleportEnable else { return }
            
            player.physicsBody?.isDynamic = false
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([remove])
            
            player.run(sequence) { [unowned self] in
                self.player.position = teleportTPosition
                self.player.physicsBody?.isDynamic = true
                self.teleportEnable = false
                self.teleportTimerStart()
                self.addChild(self.player)
            }
            
		} else if node.name == "finish" {
			nextLevel()
		}
	}
    
    func teleportTimerStart() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [unowned self] timer in
            self.teleportEnable = true
        })
    }
    
    func nextLevel() {
        self.removeAllChildren()
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        addChild(scoreLabel)

        if nowLevel < 3 {
            nowLevel += 1
        }
        
        loadLevel()
        createPlayer()
    }
}
