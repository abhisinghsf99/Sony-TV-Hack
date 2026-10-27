// Cuts a landscape's foreground out of its sky for the lock_clock depth effect.
//   depth-mask <photo.jpg> <wallpaper_front.png> [threshold] [inset]
// threshold: how far (RGB distance, 0-1.7) a pixel must be from the sky to count as ground; lower keeps pale,
// hazy ridges whole. inset: pixels the edge is pulled down, to drop a fringe of sky colour a low threshold keeps.
// Walks each column down from the top while the colour stays close to the sky just above it; the first
// pixel that breaks away for a few rows in a row is the skyline. Everything below it is kept, the sky becomes
// transparent, and the edge gets a 2 px feather. Suits clear or evenly lit skies over hills or mountains.
// Prints the skyline's highest point so the clock can be placed against it.
import Foundation
import AppKit

let args = CommandLine.arguments
guard args.count >= 3,
      let image = NSImage(contentsOfFile: args[1]),
      let cg = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    FileHandle.standardError.write("usage: depth-mask <photo.jpg> <out.png> [threshold]\n".data(using: .utf8)!)
    exit(1)
}
let threshold = args.count > 3 ? Double(args[3]) ?? 0.12 : 0.12
let inset = args.count > 4 ? Int(args[4]) ?? 0 : 0
let width = cg.width, height = cg.height
var px = [UInt8](repeating: 0, count: width * height * 4)
let space = CGColorSpaceCreateDeviceRGB()
let ctx = CGContext(data: &px, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                    space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

func rgb(_ x: Int, _ y: Int) -> (Double, Double, Double) {
    let i = (y * width + x) * 4
    return (Double(px[i]) / 255, Double(px[i + 1]) / 255, Double(px[i + 2]) / 255)
}
func distance(_ a: (Double, Double, Double), _ b: (Double, Double, Double)) -> Double {
    let (dr, dg, db) = (a.0 - b.0, a.1 - b.1, a.2 - b.2)
    return (dr * dr + dg * dg + db * db).squareRoot()
}

// Skyline per column: the sky reference follows the slow vertical gradient, and a break must last 4 rows.
let run = 4
var skyline = [Int](repeating: height, count: width)
for x in 0..<width {
    var reference = rgb(x, 0)
    var y = 1
    while y < height - run {
        let here = rgb(x, y)
        if distance(here, reference) > threshold {
            var held = true
            for k in 1..<run where distance(rgb(x, y + k), reference) <= threshold { held = false; break }
            if held { skyline[x] = y; break }
        } else {
            reference = (reference.0 * 0.8 + here.0 * 0.2, reference.1 * 0.8 + here.1 * 0.2, reference.2 * 0.8 + here.2 * 0.2)
        }
        y += 1
    }
}

// A 9-column median removes single-column spikes (a bright cloud edge, a noisy pixel).
let half = 4
var smooth = skyline
for x in 0..<width {
    let window = skyline[max(0, x - half)...min(width - 1, x + half)].sorted()
    smooth[x] = window[window.count / 2]
}

// Foreground with alpha: transparent above the skyline, opaque from 2 px below it, a ramp in between.
let feather = 2.0
for y in 0..<height {
    for x in 0..<width {
        let i = (y * width + x) * 4
        let a = max(0, min(1, (Double(y - smooth[x] - inset) + feather) / (2 * feather)))
        // Premultiplied RGBA: scale the colour with the alpha.
        px[i] = UInt8(Double(px[i]) * a)
        px[i + 1] = UInt8(Double(px[i + 1]) * a)
        px[i + 2] = UInt8(Double(px[i + 2]) * a)
        px[i + 3] = UInt8(255 * a)
    }
}

let out = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: out)
try rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: args[2]))

let top = smooth.enumerated().min { $0.element < $1.element }!
print("skyline highest point: x=\(top.offset) y=\(top.element) of \(width)x\(height)")
for fraction in stride(from: 0.1, through: 0.9, by: 0.1) {
    let x = Int(Double(width) * fraction)
    print(String(format: "  x=%4d (%2.0f%%): skyline y=%d", x, fraction * 100, smooth[x]))
}
