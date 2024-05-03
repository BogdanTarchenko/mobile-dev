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
    
    @Published var resizeSliderValue: Double?
    
    private var undoStack: [UIImage] = []
    private var redoStack: [UIImage] = []
    
    private let imageProcessingQueue = DispatchQueue(label: "imageProcessing", qos: .userInitiated, attributes: .concurrent)
    
    @Published var isProcessing = false
    
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
            originalImage = lastImage
            editedImage = lastImage
        }
    }
    
    // Redo
    func redo() {
        guard !redoStack.isEmpty else { return }
        if let redoImage = redoStack.popLast() {
            undoStack.append(editedImage ?? UIImage())
            originalImage = redoImage
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
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let rotatedImage = RotateModel.rotateImage(self.originalImage)
            
            DispatchQueue.main.async {
                self.originalImage = rotatedImage
                self.editedImage = rotatedImage
                self.isProcessing = false
            }
        }
    }
    
    func resizeImage() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let resizedImage = ResizeModel.resizeImage(self.originalImage, scale: self.resizeSliderValue)
            
            DispatchQueue.main.async {
                self.originalImage = resizedImage
                self.editedImage = resizedImage
                self.isProcessing = false
            }
        }
    }
    
    func applyNegativeFilter() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let filteredImage = FiltersModel.applyNegativeFilter(self.originalImage)
            
            DispatchQueue.main.async {
                self.originalImage = filteredImage
                self.editedImage = filteredImage
                self.isProcessing = false
            }
        }
    }
    
    func applyMosaicFilter() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let filteredImage = FiltersModel.applyMosaicFilter(self.originalImage)
            
            DispatchQueue.main.async {
                self.originalImage = filteredImage
                self.editedImage = filteredImage
                self.isProcessing = false
            }
        }
    }
    
    func applyMedianFilter() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let filteredImage = FiltersModel.applyMedianFilter(self.originalImage)
            
            DispatchQueue.main.async {
                self.originalImage = filteredImage
                self.editedImage = filteredImage
                self.isProcessing = false
            }
        }
    }
    
    // Save
    func saveImage() {
        let image = editedImage ?? UIImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
