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
    @Published var mosaicSliderValue: Int?
    @Published var rotateSliderValue: Int?
    @Published var thresholdSliderValue: Int?
    @Published var amountSliderValue: Int?
    @Published var radiusSliderValue: Int?
    
    @Published var brushSize: Double = 30
    @Published var retouchStrength: Double = 0.5
    
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
            let rotatedImage = RotateModel.rotateImage(self.originalImage, byAngle: self.rotateSliderValue)
            
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
            let filteredImage = FiltersModel.applyMosaicFilter(self.originalImage, blockSize: self.mosaicSliderValue)
            
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
    
    func applyGaussianBlurFilter() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let filteredImage = FiltersModel.applyGaussianBlurFilter(self.originalImage)
            
            DispatchQueue.main.async {
                self.originalImage = filteredImage
                self.editedImage = filteredImage
                self.isProcessing = false
            }
        }
    }
    
    func retouchImage(at point: CGPoint, in viewSize: CGSize) {
        guard let image = editedImage else { return }
        let imageSize = image.size
        let convertedPoint = convertPoint(point, fromViewSize: viewSize, toImageSize: imageSize)

        guard (0..<imageSize.width).contains(convertedPoint.x),
              (0..<imageSize.height).contains(convertedPoint.y) else {
            return
        }

        imageProcessingQueue.async {
            let filteredImage = RetouchModel.applyRetouchFilter(image, centerX: Int(convertedPoint.x), centerY: Int(convertedPoint.y), radius: Int(self.brushSize), retouchStrength: self.retouchStrength)
            
            DispatchQueue.main.async {
                self.editedImage = filteredImage
            }
        }
    }

    func convertPoint(_ point: CGPoint, fromViewSize viewSize: CGSize, toImageSize imageSize: CGSize) -> CGPoint {
        let scaleX = viewSize.width / imageSize.width
        let scaleY = viewSize.height / imageSize.height

        let scale = min(scaleX, scaleY)

        let offsetX = (viewSize.width - imageSize.width * scale) / 2
        let offsetY = (viewSize.height - imageSize.height * scale) / 2

        let correctedX = (point.x - offsetX) / scale
        let correctedY = (point.y - offsetY) / scale

        return CGPoint(x: correctedX, y: correctedY)
    }
    
    func applyUnsharpMask() {
        isProcessing = true
        addCurrentImageToChangeListArray()
        
        imageProcessingQueue.async {
            let maskedImage = UnsharpMaskModel.applyUnsharpMask(self.originalImage, threshold: self.thresholdSliderValue, amount: self.amountSliderValue, radius: self.radiusSliderValue)
            
            DispatchQueue.main.async {
                self.originalImage = maskedImage
                self.editedImage = maskedImage
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
