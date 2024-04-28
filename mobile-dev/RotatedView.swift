import SwiftUI
import CoreGraphics

struct RotatedView {
    let image: UIImage
    
    func rotateImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage
        else {
            return image
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else {
            return image
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var rotatedPixelData = [UInt8](repeating: 0, count: width * height * 4)
        for y in 0..<height {
            for x in 0..<width {
                let sourceIndex = (x + y * width) * 4
                
                let rotatedX = height - 1 - y
                let rotatedY = x
                
                let destinationIndex = (rotatedX + rotatedY * height) * 4
                
                rotatedPixelData[destinationIndex] = pixelData[sourceIndex]
                rotatedPixelData[destinationIndex + 1] = pixelData[sourceIndex + 1]
                rotatedPixelData[destinationIndex + 2] = pixelData[sourceIndex + 2]
                rotatedPixelData[destinationIndex + 3] = pixelData[sourceIndex + 3]
            }
        }
        
        guard let rotatedContext = CGContext(data: &rotatedPixelData, width: height, height: width, bitsPerComponent: 8, bytesPerRow: 4 * height, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let rotatedImage = rotatedContext.makeImage()
        else {
            return image
        }
        
        return UIImage(cgImage: rotatedImage)
    }
}
