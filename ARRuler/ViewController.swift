//
//  ViewController.swift
//  ARRuler
//
//  Created by Zahra Sadeghipoor on 3/1/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private var nodeArray = [SCNNode]()
    private var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    // MARK: - ARSCNViewDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let results = sceneView.hitTest(touch.location(in: sceneView), types: .featurePoint)
            if let result = results.first {
                let position = SCNVector3(CGFloat(result.worldTransform.columns.3.x),
                                          CGFloat(result.worldTransform.columns.3.y),
                                          CGFloat(result.worldTransform.columns.3.z))
                addPoint(at: position)
                if nodeArray.count == 2 {
                    computeDistance()
                }
            }
        }
    }
    
    func addPoint(at position: SCNVector3) {
        
        // Reset measurements
        if nodeArray.count == 2 {
            for node in nodeArray {
                node.removeFromParentNode()
            }
            nodeArray = [SCNNode]()
        }
        
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        sceneView.scene.rootNode.addChildNode(sphereNode)
        nodeArray.append(sphereNode)
    }
    
    func computeDistance() {
        let position1 = nodeArray[0].position
        let position2 = nodeArray[1].position
        
        let distance = sqrt(pow(position1.x - position2.x, 2) +
                            pow(position1.y - position2.y, 2) +
                            pow(position1.z - position2.z, 2) )
        addText("\(distance)", at: position2)
    }
    
    func addText(_ text: String, at position: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let scnText = SCNText(string: text, extrusionDepth: 0.02)
        scnText.firstMaterial?.diffuse.contents = UIColor.red
        textNode.geometry = scnText
        textNode.position = SCNVector3(CGFloat(position.x),
                                       CGFloat(position.y + 0.01),
                                       CGFloat(position.z))
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
}
