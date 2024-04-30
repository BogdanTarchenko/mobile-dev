import SwiftUI
import CoreGraphics

enum ResizedView {
    
    static func bicubicInterpolate(pixelData: [UInt8], width: Int, height: Int, x: CGFloat, y: CGFloat, c: Int) -> UInt8 {
        let xInt = Int(x)
        let yInt = Int(y)

        let xFract = x - CGFloat(xInt)
        let yFract = y - CGFloat(yInt)

        var weightsX = [CGFloat](repeating: 0, count: 4)
        var weightsY = [CGFloat](repeating: 0, count: 4)
        for i in -1...2 {
            weightsX[i + 1] = cubicWeight(xFract - CGFloat(i))
            weightsY[i + 1] = cubicWeight(yFract - CGFloat(i))
        }

        var result: CGFloat = 0
        for j in -1...2 {
            for i in -1...2 {
                let weight = weightsX[i + 1] * weightsY[j + 1]
                let color = pixelColor(xInt + i, yInt + j, c, pixelData, width, height)
                result += weight * color
            }
        }

        return UInt8(max(0, min(255, result.rounded())))
    }

    static func pixelColor(_ x: Int, _ y: Int, _ c: Int, _ pixelData: [UInt8], _ width: Int, _ height: Int) -> CGFloat {
        let index = (max(0, min(y, height - 1)) * width + max(0, min(x, width - 1))) * 4 + c
        return CGFloat(pixelData[index])
    }

    static func cubicWeight(_ value: CGFloat) -> CGFloat {
        let t = abs(value)
        if t <= 1.0 {
            return 1.5 * t * t * t - 2.5 * t * t + 1
        } else if t <= 2.0 {
            return -0.5 * t * t * t + 2.5 * t * t - 4 * t + 2
        } else {
            return 0
        }
    }


    static func resizeImage(_ image: UIImage?, scale: Double?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        guard let scale = scale else {
            return image
        }

        let width = cgImage.width
        let height = cgImage.height

        var pixelData: [UInt8] = Array(repeating: 0, count: width * height * 4)

        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return image
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let newWidth = Int(CGFloat(width) * CGFloat(scale))
        let newHeight = Int(CGFloat(height) * CGFloat(scale))
        var resizedPixelData: [UInt8] = Array(repeating: 0, count: newWidth * newHeight * 4)

        for y in 0..<newHeight {
            for x in 0..<newWidth {
                let sourceIndex = (x + y * newWidth) * 4
                for c in 0..<4 {
                    resizedPixelData[sourceIndex + c] = bicubicInterpolate(pixelData: pixelData, width: width, height: height, x: CGFloat(x) / CGFloat(scale), y: CGFloat(y) / CGFloat(scale), c: c)
                }
            }
        }

        guard let resizedContext = CGContext(data: &resizedPixelData, width: newWidth, height: newHeight, bitsPerComponent: 8, bytesPerRow: newWidth * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let resizedImage = resizedContext.makeImage() else {
            return image
        }

        UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: resizedImage), nil, nil, nil)
        return UIImage(cgImage: resizedImage)
    }

}
