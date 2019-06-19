public protocol ComplexProtocol: SignedNumeric, CustomStringConvertible, ExpressibleByFloatLiteral, Hashable {
    associatedtype T: BinaryFloatingPoint
    
    var real: T { get set }
    var imag: T { get set }
    
    init(real: T)
    init(real: T, imag: T)
    
    var conj: Self { get }
    
    @inlinable
    static func /(lhs: Self, rhs: Self) -> Self
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self)
}

extension ComplexProtocol {
    @inlinable
    public init(real: T) {
        self.init(real: real, imag: .zero)
    }
    
    @inlinable
    public init(integerLiteral value: T.IntegerLiteralType) {
        self.init(real: T(integerLiteral: value))
    }
    
    @inlinable
    public init(floatLiteral value: T.FloatLiteralType) {
        self.init(real: T(floatLiteral: value))
    }
    
    @inlinable
    public init?<I>(exactly source: I) where I : BinaryInteger {
        guard let value = T(exactly: source) else {
            return nil
        }
        self.init(real: value)
    }
    
    @inlinable
    public var description: String {
        if imag >= 0 {
            return "\(real) + \(imag)i"
        } else {
            return "\(real) - \(-imag)i"
        }
    }
    
    @inlinable
    public static var zero: Self {
        return Self(real: .zero)
    }
    
    @inlinable
    public var magnitude: T {
        if imag == 0 {
            return real.magnitude
        } else {
            return (real*real + imag*imag).squareRoot()
        }
    }
    
    @inlinable
    public var conj: Self {
        return Self(real: real, imag: -imag)
    }
    
    @inlinable
    public prefix static func - (operand: Self) -> Self {
        return Self(real: -operand.real, imag: -operand.imag)
    }
    
    @inlinable
    public mutating func negate() {
        self.real.negate()
        self.imag.negate()
    }
    
    @inlinable
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(real: lhs.real + rhs.real, imag: lhs.imag + rhs.imag)
    }
    
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.real += rhs.real
        lhs.imag += rhs.imag
    }
    
    @inlinable
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(real: lhs.real - rhs.real, imag: lhs.imag - rhs.imag)
    }
    
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.real -= rhs.real
        lhs.imag -= rhs.imag
    }
    
    @inlinable
    public static func *(lhs: Self, rhs: Self) -> Self {
        let real = lhs.real * rhs.real - lhs.imag * rhs.imag
        let imag = lhs.real * rhs.imag + lhs.imag * rhs.real
        return Self(real: real, imag: imag)
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    public static func /(lhs: Self, rhs: Self) -> Self {
        let mul = lhs * rhs.conj
        let divisor = rhs.real*rhs.real + rhs.imag*rhs.imag
        return Self(real: mul.real / divisor, imag: mul.imag / divisor)
    }
    
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
}

public struct Complex<T: BinaryFloatingPoint>: ComplexProtocol {
    public var real: T
    public var imag: T
    
    @inlinable
    public init(real: T, imag: T = .zero) {
        self.real = real
        self.imag = imag
    }
}
