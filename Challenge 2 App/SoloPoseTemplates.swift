//
//  SoloPoseTemplates.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 8/9/25.
//

import SwiftUI

struct PoseTemplates {
    static func getAllPoses() -> [PoseTemplate] {
        return [
            PoseTemplate(
                id: 1,
                name: "Arms Up",
                description: "Raise both arms above your head",
                targetKeypoints: [
                    .leftWrist: CGPoint(x: 0.3, y: 0.2),
                    .rightWrist: CGPoint(x: 0.7, y: 0.2),
                    .leftElbow: CGPoint(x: 0.35, y: 0.3),
                    .rightElbow: CGPoint(x: 0.65, y: 0.3)
                ],
                imageName: "pose1"
            ),
            PoseTemplate(
                id: 2,
                name: "T-Pose",
                description: "Extend arms horizontally",
                targetKeypoints: [
                    .leftWrist: CGPoint(x: 0.1, y: 0.4),
                    .rightWrist: CGPoint(x: 0.9, y: 0.4),
                    .leftElbow: CGPoint(x: 0.25, y: 0.4),
                    .rightElbow: CGPoint(x: 0.75, y: 0.4)
                ],
                imageName: "pose2"
            ),
            PoseTemplate(
                id: 3,
                name: "One Leg Stand",
                description: "Stand on one leg with arms out for balance",
                targetKeypoints: [
                    .leftAnkle: CGPoint(x: 0.45, y: 0.9),
                    .rightKnee: CGPoint(x: 0.6, y: 0.7),
                    .leftWrist: CGPoint(x: 0.2, y: 0.4),
                    .rightWrist: CGPoint(x: 0.8, y: 0.4)
                ],
                imageName: "pose3"
            ),
            PoseTemplate(
                id: 4,
                name: "Victory Pose",
                description: "Both arms raised in victory",
                targetKeypoints: [
                    .leftWrist: CGPoint(x: 0.25, y: 0.15),
                    .rightWrist: CGPoint(x: 0.75, y: 0.15),
                    .leftElbow: CGPoint(x: 0.3, y: 0.25),
                    .rightElbow: CGPoint(x: 0.7, y: 0.25)
                ],
                imageName: "pose4"
            )
        ]
    }
}
