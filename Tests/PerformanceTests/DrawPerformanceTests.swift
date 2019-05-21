import XCTest
import Swim

class DrawPerformanceTests: XCTestCase {
    func testDrawLine() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let pixel = Pixel<RGBA, Double>(r: 1, g: 1, b: 1, a: 1)
        
        measure {
            image.drawLine(p1: (0, 0), p2: (1919, 1079), pixel: pixel)
        }
    }
    
    func testDrawRect() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let pixel = Pixel<RGBA, Double>(r: 1, g: 1, b: 1, a: 1)
        
        measure {
            image.drawRect(origin: (0, 0), size: (1920, 1080), pixel: pixel)
        }
    }
    
    func testDrawRectPelimeter() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let pixel = Pixel<RGBA, Double>(r: 1, g: 1, b: 1, a: 1)
        
        measure {
            image.drawRectPelimeter(origin: (0, 0), size: (1920, 1080), pixel: pixel)
        }
    }
    
    func testDrawCircle() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let pixel = Pixel<RGBA, Double>(r: 1, g: 1, b: 1, a: 1)
        
        measure {
            image.drawCircle(center: (960, 540), radius: 540, pixel: pixel)
        }
    }
    
    func testDrawCirclePelimeter() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let pixel = Pixel<RGBA, Double>(r: 1, g: 1, b: 1, a: 1)
        
        measure {
            image.drawCirclePelimeter(center: (960, 540), radius: 540, pixel: pixel)
        }
    }
    
    func testDrawImage() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let draw = Image<RGBA, Double>(width: 1000, height: 70, value: 1)
        
        measure {
            image.drawImage(origin: (10, 10), image: draw)
        }
    }
    
    func testDrawImageWithmask() {
        var image = Image<RGBA, Double>(width: 1920, height: 1080, value: 0)
        let draw = Image<RGBA, Double>(width: 1000, height: 70, value: 1)
        let mask = Image<Gray, Bool>.full(value: true, like: draw)
        
        measure {
            image.drawImage(origin: (10, 10), image: draw, mask: mask)
        }
    }
}