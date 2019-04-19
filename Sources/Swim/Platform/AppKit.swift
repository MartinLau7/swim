#if canImport(AppKit)

import AppKit

extension Image where P == Intensity, T == UInt8 {
    @inlinable
    public init?(nsImage: NSImage) {
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil,hints: nil) else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    @inlinable
    public func nsImage() -> NSImage {
        return NSImage(cgImage: cgImage(), size: .zero)
    }
}

extension Image where P == RGBA, T == UInt8 {
    @inlinable
    public init?(nsImage: NSImage) {
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil,hints: nil) else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    @inlinable
    public func nsImage() -> NSImage {
        return NSImage(cgImage: cgImage(), size: .zero)
    }
}

extension Image where P == RGB, T == UInt8 {
    @inlinable
    public func nsImage() -> NSImage {
        return NSImage(cgImage: cgImage(), size: .zero)
    }
}

#endif
