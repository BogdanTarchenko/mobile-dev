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
    
    @Published var sliderValue: Double?
        
    func rotateImage() {
        editedImage = RotatedView.rotateImage(originalImage)
        originalImage = editedImage
    }
    
    func resizeImage() {
        editedImage = ResizedView.resizeImage(originalImage, scale: sliderValue)
        originalImage = editedImage
    }
    
    func saveImage() {
        let image = originalImage ?? UIImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }


}
