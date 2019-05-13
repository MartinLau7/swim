extension Image where T: AdditiveArithmetic {
    @inlinable
    public static func +=(lhs: inout Image, rhs: Image) {
        precondition(lhs.data.count == rhs.data.count, "Size mismatch.")
        
        for i in 0..<lhs.data.count {
            lhs.data[i] += rhs.data[i]
        }
    }
    
    
    @inlinable
    public static func -=(lhs: inout Image, rhs: Image) {
        precondition(lhs.data.count == rhs.data.count, "Size mismatch.")
        
        for i in 0..<lhs.data.count {
            lhs.data[i] -= rhs.data[i]
        }
    }
}

extension Image where T: Numeric {
    @inlinable
    public static func *=(lhs: inout Image, rhs: Image) {
        precondition(lhs.data.count == rhs.data.count, "Size mismatch.")
        
        for i in 0..<lhs.data.count {
            lhs.data[i] *= rhs.data[i]
        }
    }
}

extension Image where T: BinaryInteger {
    @inlinable
    public static func /=(lhs: inout Image<P, T>, rhs: Image<P, T>) {
        precondition(lhs.data.count == rhs.data.count, "Size mismatch.")
        
        for i in 0..<lhs.data.count {
            lhs.data[i] /= rhs.data[i]
        }
    }
}

extension Image where T: FloatingPoint {
    @inlinable
    public static func /=(lhs: inout Image, rhs: Image) {
        precondition(lhs.data.count == rhs.data.count, "Size mismatch.")
        
        for i in 0..<lhs.data.count {
            lhs.data[i] /= rhs.data[i]
        }
    }
}
