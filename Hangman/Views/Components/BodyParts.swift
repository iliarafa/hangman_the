import SwiftUI

struct GallowsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let baseY = rect.maxY
        let topY = rect.minY + rect.height * 0.05
        let poleX = rect.minX + rect.width * 0.25
        let beamEndX = rect.minX + rect.width * 0.6
        let ropeEndY = topY + rect.height * 0.15

        // Base
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: baseY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.42, y: baseY))

        // Vertical pole
        path.move(to: CGPoint(x: poleX, y: baseY))
        path.addLine(to: CGPoint(x: poleX, y: topY))

        // Horizontal beam
        path.addLine(to: CGPoint(x: beamEndX, y: topY))

        // Rope
        path.move(to: CGPoint(x: beamEndX, y: topY))
        path.addLine(to: CGPoint(x: beamEndX, y: ropeEndY))

        return path
    }
}

struct HeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let radius = rect.height * 0.07

        var path = Path()
        path.addEllipse(in: CGRect(
            x: centerX - radius,
            y: ropeEndY,
            width: radius * 2,
            height: radius * 2
        ))
        return path
    }
}

struct BodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let headRadius = rect.height * 0.07
        let bodyStart = ropeEndY + headRadius * 2
        let bodyEnd = bodyStart + rect.height * 0.25

        var path = Path()
        path.move(to: CGPoint(x: centerX, y: bodyStart))
        path.addLine(to: CGPoint(x: centerX, y: bodyEnd))
        return path
    }
}

struct LeftArmShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let headRadius = rect.height * 0.07
        let bodyStart = ropeEndY + headRadius * 2
        let shoulderY = bodyStart + rect.height * 0.06

        var path = Path()
        path.move(to: CGPoint(x: centerX, y: shoulderY))
        path.addLine(to: CGPoint(x: centerX - rect.width * 0.15, y: shoulderY + rect.height * 0.15))
        return path
    }
}

struct RightArmShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let headRadius = rect.height * 0.07
        let bodyStart = ropeEndY + headRadius * 2
        let shoulderY = bodyStart + rect.height * 0.06

        var path = Path()
        path.move(to: CGPoint(x: centerX, y: shoulderY))
        path.addLine(to: CGPoint(x: centerX + rect.width * 0.15, y: shoulderY + rect.height * 0.15))
        return path
    }
}

struct LeftLegShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let headRadius = rect.height * 0.07
        let bodyStart = ropeEndY + headRadius * 2
        let bodyEnd = bodyStart + rect.height * 0.25

        var path = Path()
        path.move(to: CGPoint(x: centerX, y: bodyEnd))
        path.addLine(to: CGPoint(x: centerX - rect.width * 0.12, y: bodyEnd + rect.height * 0.18))
        return path
    }
}

struct RightLegShape: Shape {
    func path(in rect: CGRect) -> Path {
        let centerX = rect.minX + rect.width * 0.6
        let topY = rect.minY + rect.height * 0.05
        let ropeEndY = topY + rect.height * 0.15
        let headRadius = rect.height * 0.07
        let bodyStart = ropeEndY + headRadius * 2
        let bodyEnd = bodyStart + rect.height * 0.25

        var path = Path()
        path.move(to: CGPoint(x: centerX, y: bodyEnd))
        path.addLine(to: CGPoint(x: centerX + rect.width * 0.12, y: bodyEnd + rect.height * 0.18))
        return path
    }
}
