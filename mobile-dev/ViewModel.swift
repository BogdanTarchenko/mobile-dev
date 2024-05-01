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
    
    private var undoStack: [UIImage] = []
    private var redoStack: [UIImage] = []
    
    private func saveCurrentImageForUndo() {
        if let currentImage = editedImage {
            undoStack.append(currentImage)
        }
    }
    
    func undo() {
        guard !undoStack.isEmpty else { return }
        if let lastImage = undoStack.popLast() {
            redoStack.append(editedImage ?? UIImage())
            editedImage = lastImage
        }
    }

    func redo() {
        guard !redoStack.isEmpty else { return }
        if let redoImage = redoStack.popLast() {
            undoStack.append(editedImage ?? UIImage())
            editedImage = redoImage
        }
    }
    
    func resetToOriginalImage() {
        editedImage = originalImage
        undoStack.removeAll()
        redoStack.removeAll()
    }

        
    func rotateImage() {
        saveCurrentImageForUndo()
        editedImage = RotatedView.rotateImage(originalImage)
        originalImage = editedImage
    }
    
    func resizeImage() {
        saveCurrentImageForUndo()
        editedImage = ResizedView.resizeImage(originalImage, scale: sliderValue)
        originalImage = editedImage
    }
    
    func saveImage() {
        let image = originalImage ?? UIImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }


}
