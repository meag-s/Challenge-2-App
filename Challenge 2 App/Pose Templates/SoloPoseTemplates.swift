//
//  SoloPoseTemplates.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 8/9/25.
//

import SwiftUI
import Vision


struct PoseTemplates {
    static func getAllPoses() -> [PoseTemplate] {
        return [
            PoseTemplate(
                id: 1,
                name: "Arms Up Victory",
                description: "Raise both arms straight up above your head",
                targetAngles: [
                    // Left arm: shoulder-elbow-wrist should be ~180° (straight)
                    JointAngle(
                        joint1: .leftShoulder,
                        joint2: .leftElbow,
                        joint3: .leftWrist,
                        targetAngle: 180,
                        tolerance: 25
                    ),
                    // Right arm: shoulder-elbow-wrist should be ~180° (straight)
                    JointAngle(
                        joint1: .rightShoulder,
                        joint2: .rightElbow,
                        joint3: .rightWrist,
                        targetAngle: 180,
                        tolerance: 25
                    ),
                    // Left shoulder angle: neck-shoulder-elbow should be ~45° (arm raised)
                    JointAngle(
                        joint1: .neck,
                        joint2: .leftShoulder,
                        joint3: .leftElbow,
                        targetAngle: 45,
                        tolerance: 20
                    ),
                    // Right shoulder angle: neck-shoulder-elbow should be ~45° (arm raised)
                    JointAngle(
                        joint1: .neck,
                        joint2: .rightShoulder,
                        joint3: .rightElbow,
                        targetAngle: 45,
                        tolerance: 20
                    )
                ],
                imageName: "pose1",
                minimumConfidence: 0.3
            ),
            
            PoseTemplate(
                id: 2,
                name: "T-Pose",
                description: "Extend both arms horizontally to your sides",
                targetAngles: [
                    // Left arm straight: shoulder-elbow-wrist ~180°
                    JointAngle(
                        joint1: .leftShoulder,
                        joint2: .leftElbow,
                        joint3: .leftWrist,
                        targetAngle: 180,
                        tolerance: 20
                    ),
                    // Right arm straight: shoulder-elbow-wrist ~180°
                    JointAngle(
                        joint1: .rightShoulder,
                        joint2: .rightElbow,
                        joint3: .rightWrist,
                        targetAngle: 180,
                        tolerance: 20
                    ),
                    // Left shoulder horizontal: neck-shoulder-elbow ~90°
                    JointAngle(
                        joint1: .neck,
                        joint2: .leftShoulder,
                        joint3: .leftElbow,
                        targetAngle: 90,
                        tolerance: 15
                    ),
                    // Right shoulder horizontal: neck-shoulder-elbow ~90°
                    JointAngle(
                        joint1: .neck,
                        joint2: .rightShoulder,
                        joint3: .rightElbow,
                        targetAngle: 90,
                        tolerance: 15
                    ),
                    // Body alignment: left shoulder-neck-right shoulder ~180°
                    JointAngle(
                        joint1: .leftShoulder,
                        joint2: .neck,
                        joint3: .rightShoulder,
                        targetAngle: 180,
                        tolerance: 20
                    )
                ],
                imageName: "pose2",
                minimumConfidence: 0.3
            ),
            
            PoseTemplate(
                id: 3,
                name: "Superhero Pose",
                description: "Place hands on hips, stand confident",
                targetAngles: [
                    // Left arm bent: shoulder-elbow-wrist ~90°
                    JointAngle(
                        joint1: .leftShoulder,
                        joint2: .leftElbow,
                        joint3: .leftWrist,
                        targetAngle: 90,
                        tolerance: 25
                    ),
                    // Right arm bent: shoulder-elbow-wrist ~90°
                    JointAngle(
                        joint1: .rightShoulder,
                        joint2: .rightElbow,
                        joint3: .rightWrist,
                        targetAngle: 90,
                        tolerance: 25
                    ),
                    // Left elbow out: neck-shoulder-elbow ~45°
                    JointAngle(
                        joint1: .neck,
                        joint2: .leftShoulder,
                        joint3: .leftElbow,
                        targetAngle: 135,
                        tolerance: 30
                    ),
                    // Right elbow out: neck-shoulder-elbow ~45°
                    JointAngle(
                        joint1: .neck,
                        joint2: .rightShoulder,
                        joint3: .rightElbow,
                        targetAngle: 135,
                        tolerance: 30
                    ),
                    // Legs straight: hip-knee-ankle ~180°
                    JointAngle(
                        joint1: .leftHip,
                        joint2: .leftKnee,
                        joint3: .leftAnkle,
                        targetAngle: 180,
                        tolerance: 20
                    )
                ],
                imageName: "pose3",
                minimumConfidence: 0.3
            ),
            
            PoseTemplate(
                id: 4,
                name: "Celebration Jump",
                description: "Raise one leg and both arms in celebration",
                targetAngles: [
                    // Left arm up: shoulder-elbow-wrist ~180°
                    JointAngle(
                        joint1: .leftShoulder,
                        joint2: .leftElbow,
                        joint3: .leftWrist,
                        targetAngle: 180,
                        tolerance: 30
                    ),
                    // Right arm up: shoulder-elbow-wrist ~180°
                    JointAngle(
                        joint1: .rightShoulder,
                        joint2: .rightElbow,
                        joint3: .rightWrist,
                        targetAngle: 180,
                        tolerance: 30
                    ),
                    // Right leg raised: hip-knee-ankle ~90° (bent knee)
                    JointAngle(
                        joint1: .rightHip,
                        joint2: .rightKnee,
                        joint3: .rightAnkle,
                        targetAngle: 90,
                        tolerance: 40
                    ),
                    // Left leg support: hip-knee-ankle ~180° (straight)
                    JointAngle(
                        joint1: .leftHip,
                        joint2: .leftKnee,
                        joint3: .leftAnkle,
                        targetAngle: 180,
                        tolerance: 25
                    ),
                    // Right thigh raised: left hip-right hip-right knee ~45°
                    JointAngle(
                        joint1: .leftHip,
                        joint2: .rightHip,
                        joint3: .rightKnee,
                        targetAngle: 45,
                        tolerance: 35
                    )
                ],
                imageName: "pose4",
                minimumConfidence: 0.25
            )
        ]
    }
}

