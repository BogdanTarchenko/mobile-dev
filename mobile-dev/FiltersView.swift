import SwiftUI
import CoreGraphics

struct FiltersView {
    let image: UIImage
    
    // Негативный фильтр
    func applyNegativeFilter(_ image: UIImage) -> UIImage {
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
        
        var negativePixelData = [UInt8](repeating: 0, count: width * height * 4)
        for y in 0..<height {
            for x in 0..<width {
                let index = (x + y * width) * 4
                
                negativePixelData[index] = 255 - pixelData[index]
                negativePixelData[index + 1] = 255 - pixelData[index + 1]
                negativePixelData[index + 2] = 255 - pixelData[index + 2]
                negativePixelData[index + 3] = pixelData[index + 3]
            }
        }
        
        guard let negativeContext = CGContext(data: &negativePixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let negativeImage = negativeContext.makeImage()
        else {
            return image
        }
        
        return UIImage(cgImage: negativeImage)
    }
    
    // Мозаика
    func applyMosaicFilter(_ image: UIImage) -> UIImage {
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
        
        var mosaicPixelData = [UInt8](repeating: 0, count: width * height * 4)
        let blockSize = 14
        for y in 0..<height {
            for x in 0..<width {
                var averageRed = 0
                var averageGreen = 0
                var averageBlue = 0
                var averageAlpha = 0
                
                // Находим срзнач цвета
                for i in 0..<blockSize {
                    for j in 0..<blockSize {
                        let index = ((x * blockSize + j) + (y * blockSize + i) * width) * 4
                        
                        if (index + 3 >= width * height * 4) {
                            break;
                        }
                        
                        averageRed += Int(pixelData[index])
                        averageGreen += Int(pixelData[index + 1])
                        averageBlue += Int(pixelData[index + 2])
                        averageAlpha += Int(pixelData[index + 3])
                    }
                }
                
                // Записываем в массив новые цвета
                for i in 0..<blockSize {
                    for j in 0..<blockSize {
                        let index = ((x * blockSize + j) + (y * blockSize + i) * width) * 4
                        
                        if (index + 3 >= width * height * 4) {
                            break;
                        }
                        
                        mosaicPixelData[index] = UInt8(averageRed / blockSize / blockSize)
                        mosaicPixelData[index + 1] = UInt8(averageGreen / blockSize / blockSize)
                        mosaicPixelData[index + 2] = UInt8(averageBlue / blockSize / blockSize)
                        mosaicPixelData[index + 3] = UInt8(averageAlpha / blockSize / blockSize)
                    }
                }
            }
        }
        
        guard let mosaicContext = CGContext(data: &mosaicPixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let mosaicImage = mosaicContext.makeImage()
        else {
            return image
        }
        
        return UIImage(cgImage: mosaicImage)
    }
    
    // Медианный фильтр
    func applyMedianFilter(_ image: UIImage) -> UIImage {
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
        
        var medianPixelData = [UInt8](repeating: 0, count: width * height * 4)
        let medianSize = 10
        
        for y in 0..<height {
            for x in 0..<width {
                let index = (x + y * width) * 4
                var redValues = [UInt8]()
                var greenValues = [UInt8]()
                var blueValues = [UInt8]()
                var alphaValues = [UInt8]()
                redValues.append(pixelData[index])
                greenValues.append(pixelData[index + 1])
                blueValues.append(pixelData[index + 2])
                alphaValues.append(pixelData[index + 3])
                
                for i in 1...medianSize / 2 {
                    for j in 1...medianSize / 2 {
                        if index - (j + i * width) * 4 >= 0 {
                            redValues.append(pixelData[index - (j + i * width) * 4])
                            greenValues.append(pixelData[index - (j + i * width) * 4 + 1])
                            blueValues.append(pixelData[index - (j + i * width) * 4 + 2])
                            alphaValues.append(pixelData[index - (j + i * width) * 4 + 3])
                        }
                        else {
                            if redValues.count - 2 >= 0 && i != 1{
                                redValues.append(redValues[redValues.count - 1])
                                greenValues.append(greenValues[greenValues.count - 1])
                                blueValues.append(blueValues[blueValues.count - 1])
                                alphaValues.append(alphaValues[alphaValues.count - 1])
                            }
                            else {
                                redValues.append(redValues[0])
                                greenValues.append(greenValues[0])
                                blueValues.append(blueValues[0])
                                alphaValues.append(alphaValues[0])
                            }
                        }
                    }
                }
                
                for i in 1...medianSize / 2 {
                    for j in 1...medianSize / 2 {
                        if index + (j + i * width) * 4 < width * height * 4 {
                            redValues.append(pixelData[index + (j + i * width) * 4])
                            greenValues.append(pixelData[index + (j + i * width) * 4 + 1])
                            blueValues.append(pixelData[index + (j + i * width) * 4 + 2])
                            alphaValues.append(pixelData[index + (j + i * width) * 4 + 3])
                        }
                        else {
                            if redValues.count - 1 >= 0 && i != 1 {
                                redValues.append(redValues[redValues.count - 1])
                                greenValues.append(greenValues[greenValues.count - 1])
                                blueValues.append(blueValues[blueValues.count - 1])
                                alphaValues.append(alphaValues[alphaValues.count - 1])
                            }
                            else {
                                redValues.append(redValues[0])
                                greenValues.append(greenValues[0])
                                blueValues.append(blueValues[0])
                                alphaValues.append(alphaValues[0])
                            }
                        }
                    }
                }
                
                redValues = redValues.sorted()
                greenValues = greenValues.sorted()
                blueValues = blueValues.sorted()
                alphaValues = alphaValues.sorted()
                
                medianPixelData[index] = redValues[redValues.count / 2]
                medianPixelData[index + 1] = greenValues[greenValues.count / 2]
                medianPixelData[index + 2] = blueValues[blueValues.count / 2]
                medianPixelData[index + 3] = alphaValues[alphaValues.count / 2]
            }
        }
        
        guard let medianContext = CGContext(data: &medianPixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let medianImage = medianContext.makeImage()
        else {
            return image
        }
        
        return UIImage(cgImage: medianImage)
    }
}
