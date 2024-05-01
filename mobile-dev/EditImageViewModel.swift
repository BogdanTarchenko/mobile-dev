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
    @Published var nonChangedImage: UIImage?
    
    @Published var sliderValue: Double?
    
    private var undoStack: [UIImage] = []
    private var redoStack: [UIImage] = []
    
    private func addCurrentImageToChangeListArray() {
        if let currentImage = editedImage {
            undoStack.append(currentImage)
        }
    }
    
    // Undo
    func undo() {
        guard !undoStack.isEmpty else { return }
        if let lastImage = undoStack.popLast() {
            redoStack.append(editedImage ?? UIImage())
            editedImage = lastImage
        }
    }
    
    // Redo
    func redo() {
        guard !redoStack.isEmpty else { return }
        if let redoImage = redoStack.popLast() {
            undoStack.append(editedImage ?? UIImage())
            editedImage = redoImage
        }
    }
    
    // Reset changes
    func resetToOriginalImage() {
        originalImage = nonChangedImage
        editedImage = nonChangedImage
        undoStack.removeAll()
        redoStack.removeAll()
    }

    // Filters
    func rotateImage() {
            addCurrentImageToChangeListArray()
            editedImage = RotatedView.rotateImage(originalImage)
            originalImage = editedImage
    }
    
    func resizeImage() {
        addCurrentImageToChangeListArray()
        editedImage = ResizedView.resizeImage(originalImage, scale: sliderValue)
        originalImage = editedImage
    }
    
    // Save
    func saveImage() {
        let image = editedImage ?? UIImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
