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

struct JointAngle {
    let joint1: VNHumanBodyPoseObservation.JointName
    let joint2: VNHumanBodyPoseObservation.JointName // center joint (vertex)
    let joint3: VNHumanBodyPoseObservation.JointName
    let targetAngle: Double // in degrees
    let tolerance: Double // acceptable deviation in degrees
}

struct PoseTemplate {
    let id: Int
    let name: String
    let description: String
    let targetAngles: [JointAngle]
    let imageName: String
    let minimumConfidence: Float
}


