//
//  JointAngle.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 8/9/25.
//

import SwiftUI
import Vision

struct JointAngle {
    let joint1: VNHumanBodyPoseObservation.JointName
    let joint2: VNHumanBodyPoseObservation.JointName // center joint (vertex)
    let joint3: VNHumanBodyPoseObservation.JointName
    let targetAngle: Double // in degrees
    let tolerance: Double // acceptable deviation in degrees
}
