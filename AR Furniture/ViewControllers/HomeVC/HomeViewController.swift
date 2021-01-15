//
//  ViewController.swift
//  AR Furniture
//
//  Created by Domagoj Kolaric on 07.12.2020..
//

import UIKit
import SceneKit
import ARKit

class HomeViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var chairBackground: UIView!
    @IBOutlet weak var tableBackground: UIView!
    @IBOutlet weak var lampBackground: UIView!
    @IBOutlet weak var removeBackground: UIView!
    
    var daeModel: String?
    
    var chosenNode = SCNNode()
    
    var furnitureVC: FurnitureViewController? {
        didSet {
            furnitureVC?.delegate = self
        }
    }
    
    private var furnitureDae: String?
    private var furnitureModelName: String?
    
    private var newAngleY: Float = 0.0
    private var currentAngleY: Float = 0.0
    private var localTranslatePosition: CGPoint!
    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.autoenablesDefaultLighting = true
        
        setupButtons()
        registerGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func registerGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSceneViewTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchedItem))
        sceneView.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pannedItem))
        sceneView.addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(moveItem))
        sceneView.addGestureRecognizer(longPress)
    }
    
    @objc func onSceneViewTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let gestureRecognizer = sender else { return }
        guard let sceneView = gestureRecognizer.view as? ARSCNView else { return }

        let touchLocation = gestureRecognizer.location(in: sceneView)
        
        let hitTestResult = self.sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitTestResult.isEmpty {
            let hitTest = hitTestResult.first!
            self.addingFurnitureItem(hitTestResult: hitTest)
        }
    }
    
    @objc func pinchedItem(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            guard let sceneView = recognizer.view as? ARSCNView else { return }
            
            let touch = recognizer.location(in: sceneView)
            
            let hitTestResult = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResult.first {
                let chairNode = hitTest.node
                let pinchScaleX = Float(recognizer.scale) * chairNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * chairNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * chairNode.scale.z
                
                chairNode.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                
                recognizer.scale = 1
            }
        }
    }
    
    @objc func pannedItem(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            guard let sceneView = recognizer.view as? ARSCNView else { return }
            
            let touch = recognizer.location(in: sceneView)
            let translation = recognizer.translation(in: sceneView)
            let hitTestResult = self.sceneView.hitTest(touch, options: nil)
            
            if let hitResult = hitTestResult.first {
                if let parentNode = hitResult.node.parent {
                    self.newAngleY = Float(translation.x) * (Float)(Double.pi)/180
                    self.newAngleY += self.currentAngleY
                    parentNode.eulerAngles.y = self.newAngleY
                }
            }
        } else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
    }
    
    @objc func moveItem(recognizer: UILongPressGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: sceneView)
        let hitTestResult = self.sceneView.hitTest(touch, options: nil)
        
        if let hitResult = hitTestResult.first {
            if let parentNode = hitResult.node.parent {
                if recognizer.state == .began { 
                    localTranslatePosition = touch
                } else if recognizer.state == .changed {
                    let deltaX = (touch.x - self.localTranslatePosition.x)/700
                    let deltaY = (touch.y - self.localTranslatePosition.y)/700
                    
                    parentNode.localTranslate(by: SCNVector3(deltaX, 0.0, deltaY))
                    localTranslatePosition = touch
                }
            }
        }
    }
    
    private func addingFurnitureItem(hitTestResult: ARHitTestResult) {
        guard let furnitureDae = self.furnitureDae, let furnitureModel = self.furnitureModelName else { return }
        
        let scene = SCNScene(named: furnitureDae)
        
        guard let newScene = scene, let chairNode = newScene.rootNode.childNode(withName: furnitureModel, recursively: true) else { return }
        
        chairNode.position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x, y: hitTestResult.worldTransform.columns.3.y, z: hitTestResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(chairNode)
    }
    

    @IBAction func addingChair(_ sender: UIButton) {
        presentFurnitureVC(type: .chair)
    }
    
    @IBAction func addingTable(_ sender: UIButton) {
        presentFurnitureVC(type: .table)
    }
    
    @IBAction func addingLamp(_ sender: UIButton) {
        presentFurnitureVC(type: .lamp)
    }
    
    @IBAction func removingNodes(_ sender: UIButton) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    private func presentFurnitureVC(type: FurnitureType) {
        self.furnitureVC = FurnitureViewController()
        furnitureVC!.modalPresentationStyle = .custom
        furnitureVC!.typeOfFurniture = type
        present(furnitureVC!, animated: true)
        {
            self.furnitureVC = nil
        }
    }
    
    private func setupButtons() {
        chairBackground.layer.cornerRadius = 3
        tableBackground.layer.cornerRadius = 3
        lampBackground.layer.cornerRadius = 3
        removeBackground.layer.cornerRadius = removeBackground.frame.size.height / 2
    }
    
}

extension HomeViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            
//            DispatchQueue.main.async {
//                self.hud.label.text = "Plane Detected"
//                self.hud.hide(animated: true, afterDelay: 1.0)
//            }
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.75)
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.x, planeAnchor.center.z)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor,
        let planeNode = node.childNodes.first,
        let plane = planeNode.geometry as? SCNPlane {
            
//            DispatchQueue.main.async {
//                self.hud.label.text = "Plane Detected"
//                self.hud.hide(animated: true, afterDelay: 1.0)
//            }
            
            plane.width = CGFloat(planeAnchor.extent.x)
            plane.height = CGFloat(planeAnchor.extent.z)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        }
    }

}

extension HomeViewController: FurnitureCellDelegate {
    func didSelectCell(furnitureDae: String, furnitureModelName: String) {
        self.furnitureDae = furnitureDae
        self.furnitureModelName = furnitureModelName
        
//        self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
//        self.hud.label.text = "Detecting Plane..."
        
        sceneView.delegate = self
    }
}
 
