// Moves a landscape down to give it more sky, for a lock_clock that needs room above the skyline.
//   sky-shift <photo.jpg> <out.jpg> <pixels>
// The picture keeps its size: it moves down by <pixels> (its bottom rows drop off) and the new top rows
// continue each column's sky gradient upward, fitted on the first 60 rows, then blurred sideways so the
// columns do not streak. Suits clear, smooth skies.
import Foundation
import AppKit

let args = CommandLine.arguments
guard args.count == 4, let shift = Int(args[3]), shift > 0,
      let image = NSImage(contentsOfFile: args[1]),
      let cg = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    FileHandle.standardError.write("usage: sky-shift <photo.jpg> <out.jpg> <pixels>\n".data(using: .utf8)!)
    exit(1)
}
let width = cg.width, height = cg.height
var src = [UInt8](repeating: 0, count: width * height * 4)
let space = CGColorSpaceCreateDeviceRGB()
let info = CGImageAlphaInfo.premultipliedLast.rawValue
CGContext(data: &src, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
          space: space, bitmapInfo: info)!.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

var out = [UInt8](repeating: 255, count: width * height * 4)
// Rows from `shift` down are the original picture, moved.
for y in shift..<height {
    let from = (y - shift) * width * 4, to = y * width * 4
    out.replaceSubrange(to..<(to + width * 4), with: src[from..<(from + width * 4)])
}

// Each channel of each column fitted as a line over rows 0..<fit, then extended to negative rows.
let fit = 60
var synth = [Double](repeating: 0, count: shift * width * 3)
for x in 0..<width {
    for c in 0..<3 {
        var sy = 0.0, sv = 0.0, syy = 0.0, syv = 0.0
        for y in 0..<fit {
            let v = Double(src[(y * width + x) * 4 + c])
            sy += Double(y); sv += v; syy += Double(y * y); syv += Double(y) * v
        }
        let n = Double(fit)
        let slope = (n * syv - sy * sv) / (n * syy - sy * sy)
        let base = (sv - slope * sy) / n
        for row in 0..<shift {
            let y = Double(row - shift)   // -shift ... -1 in the original's coordinates
            synth[(row * width + x) * 3 + c] = max(0, min(255, base + slope * y))
        }
    }
}
// Sideways box blur, radius 12, over the new rows.
let radius = 12
for row in 0..<shift {
    for x in 0..<width {
        for c in 0..<3 {
            var sum = 0.0, n = 0.0
            for k in max(0, x - radius)...min(width - 1, x + radius) { sum += synth[(row * width + k) * 3 + c]; n += 1 }
            out[(row * width + x) * 4 + c] = UInt8((sum / n).rounded())
        }
        out[(row * width + x) * 4 + 3] = 255
    }
}

let ctx = CGContext(data: &out, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                    space: space, bitmapInfo: info)!
let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
try rep.representation(using: .jpeg, properties: [.compressionFactor: 0.92])!.write(to: URL(fileURLWithPath: args[2]))
print("moved down \(shift) px; new top rows continue the sky")
