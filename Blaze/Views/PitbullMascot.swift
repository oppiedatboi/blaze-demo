import SwiftUI

enum MascotPose: String, CaseIterable {
    case waving, meditating, celebrating, sleeping, running, flexing, reading

    var assetName: String {
        "blaze-pit-\(rawValue)"
    }
}

struct PitbullMascotView: View {
    let pose: MascotPose
    var size: CGFloat = 160

    @State private var bounceOffset: CGFloat = 0

    var body: some View {
        Image(pose.assetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .offset(y: bounceOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    bounceOffset = -2
                }
            }
    }
}
