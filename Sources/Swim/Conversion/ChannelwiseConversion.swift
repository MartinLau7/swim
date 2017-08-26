
extension Image {
    public mutating func channelwiseConvert(_ f: (DT)->DT) {
        self.data.withUnsafeMutableBufferPointer {
            var p = $0.baseAddress!
            for _ in 0..<$0.count {
                p.pointee = f(p.pointee)
                p += 1
            }
        }
    }
    
    public mutating func unsafeChannelwiseConvert(_ f: (UnsafeMutableBufferPointer<T>)->Void) {
        self.data.withUnsafeMutableBufferPointer { bp in
            f(bp)
        }
    }
    
    public func unsafeChannelwiseConverted<T2: DataType>(_ f: (UnsafeBufferPointer<T>, UnsafeMutableBufferPointer<T2>)->Void) {
        var data = [T2](repeating: 0, count: width*height*PT.channels)
        self.data.withUnsafeBufferPointer { src in
            data.withUnsafeMutableBufferPointer { dst in
                f(src, dst)
            }
        }
    }
}

extension PixelSequence where Iterator == PixelIterator<PT, DT> {
    public func channelwiseConverted<T2: DataType>(_ f: (DT)->T2) -> Image<PT, T2> {
        var data = [T2](repeating: 0, count: width*height*PT.channels)
        data.withUnsafeMutableBufferPointer {
            var dst = $0.baseAddress!
            for (_, _, px) in self {
                px.data.withUnsafeBufferPointer {
                    var src = $0.baseAddress!
                    for _ in 0..<PT.channels {
                        dst.pointee = f(src.pointee)
                        src += 1
                        dst += 1
                    }
                }
            }
        }
        return Image(width: width, height: height, data: data)
    }
}
