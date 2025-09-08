//
//  PoseTemplate.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 8/9/25.
//

import SwiftUI
import AVFoundation
import Vision
import UIKit
import ImageIO
import MobileCoreServices
import Photos

struct PoseTemplate {
    let id: Int
    let name: String
    let description: String
    let targetAngles: [JointAngle]
    let imageName: String
    let minimumConfidence: Float
}

