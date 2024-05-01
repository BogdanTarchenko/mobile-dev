import SwiftUI
import CoreGraphics

enum ResizedView {
    
    static func bilinearInterpolate(pixelData: [UInt8], width: Int, height: Int, x: CGFloat, y: CGFloat, c: Int) -> UInt8 {
            let xInt = Int(x)
            let yInt = Int(y)

            let xFract = x - CGFloat(xInt)
            let yFract = y - CGFloat(yInt)

            let indexTL = ((yInt * width + xInt) * 4) + c
            let indexTR = ((yInt * width + min(xInt + 1, width - 1)) * 4) + c
            let indexBL = ((min(yInt + 1, height - 1) * width + xInt) * 4) + c
            let indexBR = ((min(yInt + 1, height - 1) * width + min(xInt + 1, width - 1)) * 4) + c

            let topLeft = CGFloat(pixelData[indexTL])
            let topRight = CGFloat(pixelData[indexTR])
            let bottomLeft = CGFloat(pixelData[indexBL])
            let bottomRight = CGFloat(pixelData[indexBR])

            let top = (1 - xFract) * topLeft + xFract * topRight
            let bottom = (1 - xFract) * bottomLeft + xFract * bottomRight

            let result = (1 - yFract) * top + yFract * bottom

            return UInt8(max(0, min(255, result.rounded())))
        }

    static func trilinearInterpolate(pixelData: [UInt8], width: Int, height: Int, x: CGFloat, y: CGFloat, zScale: CGFloat, c: Int) -> UInt8 {
            let bilinearResult = bilinearInterpolate(pixelData: pixelData, width: width, height: height, x: x, y: y, c: c)
            let scaledResult = CGFloat(bilinearResult) * zScale + CGFloat(bilinearResult) * (1 - zScale)
            return UInt8(max(0, min(255, scaledResult.rounded())))
        }



    static func applyBoxBlur(pixelData: inout [UInt8], width: Int, height: Int, radius: Int) {
        var tempPixelData = pixelData

        for y in 0..<height {
            for x in 0..<width {
                var r: Int = 0, g: Int = 0, b: Int = 0
                var count: Int = 0

                for j in -radius...radius {
                    for i in -radius...radius {
                        let px = x + i
                        let py = y + j
                        if px >= 0 && px < width && py >= 0 && py < height {
                            let index = (py * width + px) * 4
                            r += Int(pixelData[index])
                            g += Int(pixelData[index + 1])
                            b += Int(pixelData[index + 2])
                            count += 1
                        }
                    }
                }

                let newIndex = (y * width + x) * 4
                tempPixelData[newIndex] = UInt8(r / count)
                tempPixelData[newIndex + 1] = UInt8(g / count)
                tempPixelData[newIndex + 2] = UInt8(b / count)
            }
        }

        pixelData = tempPixelData
    }



    static func resizeImage(_ image: UIImage?, scale: Double?, zScale: CGFloat = 2.0) -> UIImage? {
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

        if scale > 1 {
            for y in 0..<newHeight {
                for x in 0..<newWidth {
                    let sourceIndex = (x + y * newWidth) * 4
                    for c in 0..<4 {
                        resizedPixelData[sourceIndex + c] = bilinearInterpolate(pixelData: pixelData, width: width, height: height, x: CGFloat(x) / CGFloat(scale), y: CGFloat(y) / CGFloat(scale), c: c)
                    }
                }
            }
        }
        else{
            for y in 0..<newHeight {
                        for x in 0..<newWidth {
                            let sourceIndex = (x + y * newWidth) * 4
                            for c in 0..<4 {
                                resizedPixelData[sourceIndex + c] = trilinearInterpolate(pixelData: pixelData, width: width, height: height, x: CGFloat(x) / CGFloat(scale), y: CGFloat(y) / CGFloat(scale), zScale: zScale, c: c)
                            }
                        }
                    }
        }
    
        
        applyBoxBlur(pixelData: &resizedPixelData, width: newWidth, height: newHeight, radius: 1)

        guard let resizedContext = CGContext(data: &resizedPixelData, width: newWidth, height: newHeight, bitsPerComponent: 8, bytesPerRow: newWidth * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let resizedImage = resizedContext.makeImage() else {
            return image
        }

        
        return UIImage(cgImage: resizedImage)
    }

}
