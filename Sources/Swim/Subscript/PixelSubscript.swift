
extension Image {
    func getPixel(x: Int, y: Int, c: Int = 0) -> T {
        return data[index(x: x, y: y, c: c)]
    }
    
    mutating func setPixel(x: Int, y: Int, c: Int = 0, newValue: T) {
        data[index(x: x, y: y, c: c)] = newValue
    }
    
    func getPixel(x: Int, y: Int) -> Pixel<P, T> {
        let start = index(x: x, y: y)
        return Pixel(data: [T](data[start..<start+P.channels]))
    }
    
    mutating func setPixel(x: Int, y: Int, newValue: Pixel<P, T>) {
        let start = index(x: x, y: y)
        self.data.replaceSubrange(start..<start+P.channels, with: newValue.data)
    }
    
}

extension Image where P == Intensity {
    public subscript(x: Int, y: Int) -> T {
        get {
            return self.getPixel(x: x, y: y)
        }
        set {
            self.setPixel(x: x, y: y, newValue: newValue)
        }
    }
}

extension Image {
    public subscript(x: Int, y: Int, c: Int) -> T {
        get {
            return self.getPixel(x: x, y: y, c: c)
        }
        set {
            self.setPixel(x: x, y: y, c: c, newValue: newValue)
        }
    }
    
    public subscript(x: Int, y: Int) -> Pixel<P, T> {
        get {
            return self.getPixel(x: x, y: y)
        }
        set {
            self.setPixel(x: x, y: y, newValue: newValue)
        }
    }
}
