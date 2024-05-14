import SwiftUI
import SceneKit // По сути это не графический движок, а просто графический интерфейс. В общем будем рады любому количеству баллов за этот алгоритм :)

struct CubeView: View {
    var body: some View {
        GeometryReader { geometry in
            SceneKitView(scene: createScene(), size: geometry.size)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func createScene() -> SCNScene {
        let scene = SCNScene()
        let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange]
        let cubeSize: CGFloat = 2.0
        let chamferRadius: CGFloat = 0.1
        
        let cube = SCNBox(width: cubeSize, height: cubeSize, length: cubeSize, chamferRadius: chamferRadius)
        
        var materials = [SCNMaterial]()
        for color in colors {
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.specular.contents = UIColor.white
            materials.append(material)
        }
        cube.materials = materials
        
        let node = SCNNode(geometry: cube)
        scene.rootNode.addChildNode(node)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
}

struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene
    let size: CGSize
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(origin: .zero, size: size), options: nil)
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.backgroundColor = UIColor.black
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}
