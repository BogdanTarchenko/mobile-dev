import SwiftUI

class EditImageViewModel: ObservableObject {
    @Published var originalImage: UIImage? {
        didSet {
            editedImage = originalImage
        }
    }
    
    var originalImageData: Data? {
        didSet {
            if let imageData = originalImageData {
                originalImage = UIImage(data: imageData)
            }
        }
    }
    
    @Published var editedImage: UIImage?
        
    func rotateImage() {
        editedImage = RotatedView.rotateImage(originalImage)
        originalImage = editedImage
    }
}
