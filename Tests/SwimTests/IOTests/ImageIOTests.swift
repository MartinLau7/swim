import XCTest
import Swim

class ImageIOTests: XCTestCase {
    
    let srcPath = URL(fileURLWithPath: "/tmp/swim_test_src.png")
    let dstPath = URL(fileURLWithPath: "/tmp/swim_test_dst.png")
    
    var baseImage: Image<RGBA, UInt8>!
    var baseLuminance: Image<Gray, UInt8>!
    
    override func setUp() {
        self.baseImage = Image(width: 128,
                               height: 128,
                               data: (0..<128*128*4).map { UInt8($0 % Int(UInt8.max)) })
        self.baseLuminance = Image(width: 128,
                                   height: 128,
                                   data: (0..<128*128).map { UInt8($0 % Int(UInt8.max)) })
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: srcPath)
        try? FileManager.default.removeItem(at: dstPath)
    }
    
    func testSaveLoadUInt8() {
        do { // RGBA
            try! self.baseImage.write(to: srcPath)
            
            let image = try? Image<RGBA, UInt8>(contentsOf: srcPath)
            
            XCTAssertEqual(image, baseImage)
        }
        do { // Gray
            try! self.baseLuminance.write(to: srcPath, format: .png)
            
            let image = try? Image<Gray, UInt8>(contentsOf: srcPath)
            
            XCTAssertEqual(image, baseLuminance)
        }
        do { // read Gray as GrayAlpha
            try! self.baseLuminance.write(to: srcPath, format: .png)
            
            let image = try? Image<GrayAlpha, UInt8>(contentsOf: srcPath)
            
            XCTAssertEqual(image?[channel: .gray], baseLuminance)
            
            try? image?.write(to: dstPath)
            
            let image2 = try? Image<GrayAlpha, UInt8>(contentsOf: dstPath)
            
            XCTAssertEqual(image, image2)
        }
        do { // read Gray as RGB
            try! self.baseLuminance.write(to: srcPath, format: .png)
            
            let image = try? Image<RGB, UInt8>(contentsOf: srcPath)
            
            XCTAssertEqual(image?[channel: .red], baseLuminance)
            
            try? image?.write(to: dstPath)
            
            let image2 = try? Image<RGB, UInt8>(contentsOf: dstPath)
            
            XCTAssertEqual(image, image2)
        }
        do { // read Gray as RGBA
            try! self.baseLuminance.write(to: srcPath, format: .png)
            
            let image = try? Image<RGBA, UInt8>(contentsOf: srcPath)
            
            XCTAssertEqual(image?[channel: .red], baseLuminance)
            
            try? image?.write(to: dstPath)
            
            let image2 = try? Image<RGBA, UInt8>(contentsOf: dstPath)
            
            XCTAssertEqual(image, image2)
        }
        do { // read RGBA as Gray
            try! self.baseImage.write(to: srcPath)
            
            let image = try? Image<Gray, UInt8>(contentsOf: srcPath)
            
            XCTAssertNil(image)
        }
    }
    
    func testSaveLoadFloat() {
        do {
            try! self.baseImage.write(to: srcPath)
            let image = try! Image<RGBA, Float>(contentsOf: srcPath)
            
            XCTAssertEqual((image*255).round().cast(), baseImage)
            
            try! image.write(to: dstPath)
            
            let reloaded = try! Image<RGBA, Float>(contentsOf: dstPath)
            
            XCTAssertEqual(reloaded, image)
        }
        do {
            try! self.baseLuminance.write(to: srcPath, format: .png)
            let image = try! Image<Gray, Float>(contentsOf: srcPath)
            
            XCTAssertEqual((image*255).round().cast(), baseLuminance)
            
            try! image.write(to: dstPath, format: .png)
            
            let reloaded = try! Image<Gray, Float>(contentsOf: dstPath)
            
            XCTAssertEqual(reloaded, image)
        }
    }
    
    func testSaveLoadDouble() {
        do {
            try! self.baseImage.write(to: srcPath)
            
            let image = try! Image<RGBA, Double>(contentsOf: srcPath)
            
            XCTAssertEqual((image*255).round().cast(), baseImage)
            
            try! image.write(to: dstPath)
            
            let reloaded = try! Image<RGBA, Double>(contentsOf: dstPath)
            
            XCTAssertEqual(reloaded, image)
        }
        do {
            try! self.baseLuminance.write(to: srcPath, format: .png)
            
            let image = try! Image<Gray, Double>(contentsOf: srcPath)
            
            XCTAssertEqual((image*255).round().cast(), baseLuminance)
            
            try! image.write(to: dstPath, format: .png)
            
            let reloaded = try! Image<Gray, Double>(contentsOf: dstPath)
            
            XCTAssertEqual(reloaded, image)
        }
    }
    
    func testInscribeUInt8() {
        do { // RGBA
            let image = self.baseImage!
            
            try! image.write(to: srcPath)

            let data = try! image.inscribe()
            
            XCTAssertEqual(data, try! Data(contentsOf: srcPath))
        }
        do { // RGB
            let image = self.baseImage.toRGB()
            
            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
        do { // Grey
            let image = self.baseLuminance!

            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
    }
    
    func testInscribeFloat() {
        do { // RGBA
            let image = (self.baseImage / UInt8.max).cast(to: Float.self)
            
            try! image.write(to: srcPath)

            let data = try! image.inscribe()
            
            XCTAssertEqual(data, try! Data(contentsOf: srcPath))
        }
        do { // RGB
            let image = (self.baseImage.toRGB() / UInt8.max).cast(to: Float.self)
            
            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
        do { // Grey
            let image = (self.baseLuminance / UInt8.max).cast(to: Float.self)

            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
    }
    
    func testInscribeDouble() {
        do { // RGBA
            let image = (self.baseImage / UInt8.max).cast(to: Double.self)
            
            try! image.write(to: srcPath)

            let data = try! image.inscribe()
            
            XCTAssertEqual(data, try! Data(contentsOf: srcPath))
        }
        do { // RGB
            let image = (self.baseImage.toRGB() / UInt8.max).cast(to: Double.self)
            
            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
        do { // Grey
            let image = (self.baseLuminance / UInt8.max).cast(to: Double.self)

            for format in WriteFormat.all {
                try! image.write(to: srcPath, format: format)

                let data = try! image.inscribe(format: format)

                XCTAssertEqual(data, try! Data(contentsOf: srcPath))
            }
        }
    }
    
    static let allTests = [
        ("testSaveLoadUInt8", testSaveLoadUInt8),
        ("testSaveLoadFloat", testSaveLoadFloat),
        ("testSaveLoadDouble", testSaveLoadDouble),
        ("testInscribeUInt8", testInscribeUInt8),
        ("testInscribeFloat", testInscribeFloat),
        ("testInscribeDouble", testInscribeDouble)
    ]
}

fileprivate extension WriteFormat {
    static let all: [WriteFormat] = [.bitmap, .jpeg(quality: 90), .png]
}
