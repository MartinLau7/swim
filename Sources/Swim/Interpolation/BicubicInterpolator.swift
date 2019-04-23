import Foundation

public struct BicubicInterpolator<P: PixelType, T: BinaryFloatingPoint&DataType>: Interpolator {
    public var a: T
    public var edgeMode: EdgeMode<P, T>
    
    public init(a: T = -1, edgeMode: EdgeMode<P, T> = .constant(value: 0)) {
        self.a = a
        self.edgeMode = edgeMode
    }
    
    @inlinable
    func bicubicWeight(distance: T) -> T {
        guard distance < 2 else {
            return 0
        }
        let d2 = distance*distance
        let d3 = d2*distance
        
        if distance < 1 {
            var result = (a+2) * d3
            result -= (a+3)*d2
            return result + 1
        } else {
            var result = a*d3
            result -= 5*a*d2
            result += 8*a*distance
            return result - 4*a
        }
    }
    
    @inlinable
    public func interpolate(x: T, y: T, in image: Image<P, T>) -> Pixel<P, T> {
        let xmin = floor(x) - 1
        let ymin = floor(y) - 1
        
        var result = Pixel<P, T>(value: 0)
        
        var constant: Pixel<P, T>?
        switch edgeMode {
        case let .constant(px):
            constant = px
        default:
            constant = nil
        }
        
        // weights
        let xw0 = bicubicWeight(distance: x - xmin)
        let xw1 = bicubicWeight(distance: x - xmin - 1)
        let xw2 = bicubicWeight(distance: xmin + 2 - x)
        let xw3 = bicubicWeight(distance: xmin + 3 - x)
        
        let yw0 = bicubicWeight(distance: y - ymin)
        let yw1 = bicubicWeight(distance: y - ymin - 1)
        let yw2 = bicubicWeight(distance: ymin + 2 - y)
        let yw3 = bicubicWeight(distance: ymin + 3 - y)
        
        // Loop unrolling
        var yp = Int(ymin)
        
        // dy = 0
        do {
            var xp = Int(xmin)
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw0 * yw0 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw0 * yw0 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw1 * yw0 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw1 * yw0 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw2 * yw0 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw2 * yw0 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw3 * yw0 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw3 * yw0 * constant
            } else {
                fatalError("Never happens.")
            }
        }
        yp += 1

        // dy = 1
        do {
            var xp = Int(xmin)
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw0 * yw1 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw0 * yw1 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw1 * yw1 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw1 * yw1 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw2 * yw1 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw2 * yw1 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw3 * yw1 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw3 * yw1 * constant
            } else {
                fatalError("Never happens.")
            }
        }
        yp += 1
        
        // dy = 2
        do {
            var xp = Int(xmin)
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw0 * yw2 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw0 * yw2 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw1 * yw2 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw1 * yw2 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw2 * yw2 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw2 * yw2 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw3 * yw2 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw3 * yw2 * constant
            } else {
                fatalError("Never happens.")
            }
        }
        yp += 1
        
        // dy = 3
        do {
            var xp = Int(xmin)
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw0 * yw3 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw0 * yw3 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw1 * yw3 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw1 * yw3 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw2 * yw3 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw2 * yw3 * constant
            } else {
                fatalError("Never happens.")
            }
            xp += 1
            
            if let coord = inImageCoord(x: xp, y: yp, width: image.width, height: image.height) {
                for c in 0..<P.channels {
                    result[c] += xw3 * yw3 * image[unsafe: coord.x, coord.y, c]
                }
            } else if let constant = constant {
                result += xw3 * yw3 * constant
            } else {
                fatalError("Never happens.")
            }
        }
        
        return result
    }
}

/// Slower but simpler version
public struct _BicubicInterpolator<P: PixelType, T: BinaryFloatingPoint&DataType>: Interpolator {
    public var a: T
    public var edgeMode: EdgeMode<P, T>
    
    public init(a: T = -1, edgeMode: EdgeMode<P, T> = .constant(value: 0)) {
        self.a = a
        self.edgeMode = edgeMode
    }
    
    @inlinable
    func bicubicWeight(distance: T) -> T {
        guard distance < 2 else {
            return 0
        }
        let d2 = distance*distance
        let d3 = d2*distance
        
        if distance < 1 {
            var result = (a+2) * d3
            result -= (a+3)*d2
            return result + 1
        } else {
            var result = a*d3
            result -= 5*a*d2
            result += 8*a*distance
            return result - 4*a
        }
    }
    
    @inlinable
    public func interpolate(x: T, y: T, in image: Image<P, T>) -> Pixel<P, T> {
        let xmin = floor(x) - 1
        let ymin = floor(y) - 1
        
        var result = Pixel<P, T>(value: 0)
        
        for dy in 0..<4 {
            let yp = ymin + T(dy)
            let wy = bicubicWeight(distance: abs(yp - y))
            for dx in 0..<4 {
                let xp = xmin + T(dx)
                let wx = bicubicWeight(distance: abs(xp - x))
                
                let px = getPixel(x: Int(xp), y: Int(yp), in: image)
                
                result += wx * wy * px
            }
        }
        
        return result
    }
}
