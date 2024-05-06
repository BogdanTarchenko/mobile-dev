import SwiftUI
import CoreGraphics

enum FiltersModel {
    // Negative
    static func applyNegativeFilter(_ image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return image
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var negativePixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        DispatchQueue.concurrentPerform(iterations: height) { y in
            for x in 0..<width {
                let index = (x + y * width) * 4
                
                negativePixelData[index] = 255 - pixelData[index]
                negativePixelData[index + 1] = 255 - pixelData[index + 1]
                negativePixelData[index + 2] = 255 - pixelData[index + 2]
                negativePixelData[index + 3] = pixelData[index + 3]
            }
        }
        
        guard let negativeContext = CGContext(data: &negativePixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let negativeImage = negativeContext.makeImage() else {
            return image
        }
        
        return UIImage(cgImage: negativeImage)
    }
    
    // Mosaic
    static func applyMosaicFilter(_ image: UIImage?, blockSize: Int?) -> UIImage? {
        guard let cgImage = image?.cgImage, let blockSize = blockSize else {
            return image
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return image
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var mosaicPixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        DispatchQueue.concurrentPerform(iterations: height) { y in
            for x in 0..<width {
                var totalRed = 0
                var totalGreen = 0
                var totalBlue = 0
                var totalAlpha = 0
                
                for i in 0..<blockSize {
                    for j in 0..<blockSize {
                        let pixelX = min(max(x * blockSize + j, 0), width - 1)
                        let pixelY = min(max(y * blockSize + i, 0), height - 1)
                        let index = (pixelX + pixelY * width) * 4
                        
                        totalRed += Int(pixelData[index])
                        totalGreen += Int(pixelData[index + 1])
                        totalBlue += Int(pixelData[index + 2])
                        totalAlpha += Int(pixelData[index + 3])
                    }
                }
                
                let count = blockSize * blockSize
                let averageRed = UInt8(totalRed / count)
                let averageGreen = UInt8(totalGreen / count)
                let averageBlue = UInt8(totalBlue / count)
                let averageAlpha = UInt8(totalAlpha / count)
                
                for i in 0..<blockSize {
                    for j in 0..<blockSize {
                        let pixelX = min(max(x * blockSize + j, 0), width - 1)
                        let pixelY = min(max(y * blockSize + i, 0), height - 1)
                        let index = (pixelX + pixelY * width) * 4
                        
                        mosaicPixelData[index] = averageRed
                        mosaicPixelData[index + 1] = averageGreen
                        mosaicPixelData[index + 2] = averageBlue
                        mosaicPixelData[index + 3] = averageAlpha
                    }
                }
            }
        }
        
        guard let mosaicContext = CGContext(data: &mosaicPixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let mosaicImage = mosaicContext.makeImage() else {
            return image
        }
        
        return UIImage(cgImage: mosaicImage)
    }

    
    // Median
    static func applyMedianFilter(_ image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        var pixelData = [UInt8](repeating: 0, count: width * height * 4)
        
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return image
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var medianPixelData = [UInt8](repeating: 0, count: width * height * 4)
        let medianSize = 7
        
        DispatchQueue.concurrentPerform(iterations: height) { y in
            for x in 0..<width {
                var redValues = [UInt8]()
                var greenValues = [UInt8]()
                var blueValues = [UInt8]()
                var alphaValues = [UInt8]()
                
                for i in -medianSize/2...medianSize/2 {
                    for j in -medianSize/2...medianSize/2 {
                        let pixelX = min(max(x + j, 0), width - 1)
                        let pixelY = min(max(y + i, 0), height - 1)
                        let index = (pixelX + pixelY * width) * 4
                        
                        redValues.append(pixelData[index])
                        greenValues.append(pixelData[index + 1])
                        blueValues.append(pixelData[index + 2])
                        alphaValues.append(pixelData[index + 3])
                    }
                }
                
                redValues.sort()
                greenValues.sort()
                blueValues.sort()
                alphaValues.sort()
                
                let medianIndex = redValues.count / 2
                let medianRed = redValues[medianIndex]
                let medianGreen = greenValues[medianIndex]
                let medianBlue = blueValues[medianIndex]
                let medianAlpha = alphaValues[medianIndex]
                
                let index = (x + y * width) * 4
                medianPixelData[index] = medianRed
                medianPixelData[index + 1] = medianGreen
                medianPixelData[index + 2] = medianBlue
                medianPixelData[index + 3] = medianAlpha
            }
        }
        
        guard let medianContext = CGContext(data: &medianPixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let medianImage = medianContext.makeImage() else {
            return image
        }
        
        return UIImage(cgImage: medianImage)
    }

}
