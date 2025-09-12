import SwiftUI
import Vision
import AVFoundation
import Observation



struct BodyConnection: Identifiable {
    let id = UUID()
    let from: HumanBodyPoseObservation.JointName
    let to: HumanBodyPoseObservation.JointName
}


// MARK: - Pose Estimation ViewModel
@Observable
class PoseEstimationViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var PoseDetected: Int = 0
    var detectedBodyParts: [HumanBodyPoseObservation.JointName: CGPoint] = [:]
    var bodyConnections: [BodyConnection] = []
    
    override init() {
        super.init()
        setupBodyConnections()
    }
    
    private func setupBodyConnections() {
        bodyConnections = [
            BodyConnection(from: .nose, to: .neck),
            BodyConnection(from: .neck, to: .rightShoulder),
            BodyConnection(from: .neck, to: .leftShoulder),
            BodyConnection(from: .rightShoulder, to: .rightHip),
            BodyConnection(from: .leftShoulder, to: .leftHip),
            BodyConnection(from: .rightHip, to: .leftHip),
            BodyConnection(from: .rightShoulder, to: .rightElbow),
            BodyConnection(from: .rightElbow, to: .rightWrist),
            BodyConnection(from: .leftShoulder, to: .leftElbow),
            BodyConnection(from: .leftElbow, to: .leftWrist),
            BodyConnection(from: .rightHip, to: .rightKnee),
            BodyConnection(from: .rightKnee, to: .rightAnkle),
            BodyConnection(from: .leftHip, to: .leftKnee),
            BodyConnection(from: .leftKnee, to: .leftAnkle)
        ]
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        Task {
            if let detectedPoints = await processFrame(sampleBuffer) {
                DispatchQueue.main.async {
                    self.detectedBodyParts = detectedPoints
                }
            }
        }
    }
    
    func processFrame(_ sampleBuffer: CMSampleBuffer) async -> [HumanBodyPoseObservation.JointName: CGPoint]? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        let request = DetectHumanBodyPoseRequest()
        
        do {
            let results = try await request.perform(on: imageBuffer, orientation: .none)
            if let observation = results.first {
                PoseDetected = PoseCheck(observation: observation)
                return extractPoints(from: observation)
            }
        } catch {
            print("Error processing frame: \(error.localizedDescription)")
        }
        
        return nil
    }
    private func extractPoints(from observation: HumanBodyPoseObservation) -> [HumanBodyPoseObservation.JointName: CGPoint] {
        var detectedPoints: [HumanBodyPoseObservation.JointName: CGPoint] = [:]
        let humanJoints: [HumanBodyPoseObservation.PoseJointsGroupName] = [.face, .torso, .leftArm, .rightArm, .leftLeg, .rightLeg]
        
        for groupName in humanJoints {
            let jointsInGroup = observation.allJoints(in: groupName)
            for (jointName, joint) in jointsInGroup {
                if joint.confidence > 0.5 { // Ensuring only high-confidence joints are added
                    let point = joint.location.verticallyFlipped().cgPoint
                    detectedPoints[jointName] = point
                }
            }
        }
        return detectedPoints
    }
    func angleBetween(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> CGFloat {
        let ab = CGVector(dx: b.x - a.x, dy: b.y - a.y)
        let cb = CGVector(dx: b.x - c.x, dy: b.y - c.y)
        
        let dotProduct = ab.dx * cb.dx + ab.dy * cb.dy
        let magnitudeAB = sqrt(ab.dx * ab.dx + ab.dy * ab.dy)
        let magnitudeCB = sqrt(cb.dx * cb.dx + cb.dy * cb.dy)
        
        let angle = acos(dotProduct / (magnitudeAB * magnitudeCB))
        return angle * 180 / .pi
    }
    func PoseCheck1(observation: HumanBodyPoseObservation) -> Int? {
        let points = extractPoints(from: observation)
        
        // Ensure all required points exist
        guard let leftWrist = points[.leftWrist],
              let leftElbow = points[.leftElbow],
              let leftShoulder = points[.leftShoulder],
              let neck = points[.neck],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist] else {
            print("Some points are missing")
            return nil
        }
        
        // Calculate angles
        let leftElbowAngle = angleBetween(leftWrist, leftElbow, leftShoulder)       // 90°
        let LeftneckAngle = angleBetween(neck, leftShoulder, leftElbow)             // 180°
        let RightneckAngle = angleBetween(neck, rightShoulder, rightElbow)          // 180°
        let shouldersAngle = angleBetween(rightShoulder, neck, leftShoulder)        // 135°
        let rightElbowAngle = angleBetween(rightWrist, rightElbow, rightShoulder)   // 45°
        let rightArmAngle = angleBetween(rightElbow, rightShoulder, neck)           // 165°
        
        // Tolerance ±40°
        let leftElbowOK = (leftElbowAngle > 70 && leftElbowAngle < 110)
        let neckOK = (LeftneckAngle > 100 && LeftneckAngle < 150)
        let shouldersOK = (shouldersAngle > 140 && shouldersAngle <= 180)
        let rightElbowOK = (rightElbowAngle > 60 && rightElbowAngle < 100)
        let rightArmOK = (rightArmAngle > 140 && rightArmAngle < 180)
        
        // Print individual checks
        leftElbowOK ? print("No issue with left elbow") : print("Check left elbow: \(leftElbowAngle)°")
        neckOK ? print("No issue with neck") : print("Check neck: \(LeftneckAngle)°")
        shouldersOK ? print("No issue with shoulder span") : print("Check shoulder span: \(shouldersAngle)°")
        rightElbowOK ? print("No issue with right elbow") : print("Check right elbow: \(rightElbowAngle)°")
        rightArmOK ? print("No issue with right arm") : print("Check right arm: \(rightArmAngle)°")
        
        if leftElbowOK && neckOK && shouldersOK && rightElbowOK && rightArmOK{
            print("Fruity Pose DETECTED")
            return 1
        }
        return nil
    }
    
    func PoseCheck2(observation: HumanBodyPoseObservation) -> Int? {
        let points = extractPoints(from: observation)
        
        // Ensure all required points exist
        guard let leftWrist = points[.leftWrist],
              let leftElbow = points[.leftElbow],
              let leftShoulder = points[.leftShoulder],
              let neck = points[.neck],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist] else {
            print("Some points are missing")
            return nil
        }
        
        // Calculate angles
        let leftElbowAngle = angleBetween(leftWrist, leftElbow, leftShoulder)       // 90°
        let LeftneckAngle = angleBetween(neck, leftShoulder, leftElbow)             // 180°
        let RightneckAngle = angleBetween(neck, rightShoulder, rightElbow)          // 180°
        let shouldersAngle = angleBetween(rightShoulder, neck, leftShoulder)        // 135°
        let rightElbowAngle = angleBetween(rightWrist, rightElbow, rightShoulder)   // 45°
        
        // Tolerance ±40°
        let leftElbowOK = (leftElbowAngle > 140 && leftElbowAngle <= 180)
        let LeftNeckOK = (LeftneckAngle > 25 && LeftneckAngle < 65)
        let RightNeckOK = (RightneckAngle > 25 && RightneckAngle < 65)
        let rightElbowOK = (rightElbowAngle > 140 && rightElbowAngle <= 180)
        
        // Print individual checks
        leftElbowOK ? print("No issue with left elbow") : print("Check left elbow: \(leftElbowAngle)°")
        LeftNeckOK ? print("No issue with left neck") : print("Check left neck: \(LeftneckAngle)°")
        RightNeckOK ? print("No issue with right neck") : print("Check left neck: \(RightneckAngle)°")
        rightElbowOK ? print("No issue with right elbow") : print("Check right elbow: \(rightElbowAngle)°")
        
        if leftElbowOK && LeftNeckOK && RightNeckOK && rightElbowOK{
            print("Victory Pose DETECTED")
            return 2
        }
        return nil
    }
    func PoseCheck3(observation: HumanBodyPoseObservation) -> Int? {
        let points = extractPoints(from: observation)
        
        // Ensure all required points exist
        guard let leftWrist = points[.leftWrist],
              let leftElbow = points[.leftElbow],
              let leftShoulder = points[.leftShoulder],
              let neck = points[.neck],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist] else {
            print("Some points are missing")
            return nil
        }
        
        // Calculate angles
        let leftElbowAngle = angleBetween(leftWrist, leftElbow, leftShoulder)       // 180°
        let LeftneckAngle = angleBetween(neck, leftShoulder, leftElbow)             // 90°
        let RightneckAngle = angleBetween(neck, rightShoulder, rightElbow)          // 90°
        let shouldersAngle = angleBetween(rightShoulder, neck, leftShoulder)        // 180°
        let rightElbowAngle = angleBetween(rightWrist, rightElbow, rightShoulder)   // 180°
  
        // Tolerance ±40°
        let leftElbowOK = (leftElbowAngle > 140 && leftElbowAngle <= 180)
        let LeftNeckOK = (LeftneckAngle > 70 && LeftneckAngle < 110)
        let RightNeckOK = (RightneckAngle > 70 && RightneckAngle < 110)
        let shouldersAngleOK = (shouldersAngle > 140 && shouldersAngle <= 180)
        let rightElbowOK = (rightElbowAngle > 140 && rightElbowAngle <= 180)
        
        // Print individual checks
        leftElbowOK ? print("No issue with left elbow") : print("Check left elbow: \(leftElbowAngle)°")
        LeftNeckOK ? print("No issue with left neck") : print("Check left neck: \(LeftneckAngle)°")
        RightNeckOK ? print("No issue with right neck") : print("Check left neck: \(RightneckAngle)°")
        shouldersAngleOK ? print("No issue with right elbow") : print("Check right elbow: \(shouldersAngle)°")
        rightElbowOK ? print("No issue with right elbow") : print("Check right elbow: \(rightElbowAngle)°")
        
        if leftElbowOK && LeftNeckOK && RightNeckOK && rightElbowOK && shouldersAngleOK{
            print("T-pose DETECTED")
            return 3
        }
        return nil
    }
    func PoseCheck4(observation: HumanBodyPoseObservation) -> Int? {
        let points = extractPoints(from: observation)
        
        // Ensure all required points exist
        guard let leftWrist = points[.leftWrist],
              let leftElbow = points[.leftElbow],
              let leftShoulder = points[.leftShoulder],
              let neck = points[.neck],
              let rightShoulder = points[.rightShoulder],
              let rightElbow = points[.rightElbow],
              let rightWrist = points[.rightWrist],
              let leftHip = points[.leftHip],
              let leftKnee = points[.leftKnee],
              let leftAnkle = points[.leftAnkle],
              let rightHip = points[.rightHip],
              let rightKnee = points[.rightKnee],
              let rightAnkle = points[.rightAnkle] else {
            print("Some points are missing")
            return nil
        }
        
        // Calculate angles
        let leftElbowAngle = angleBetween(leftWrist, leftElbow, leftShoulder)       // 90°
        let LeftneckAngle = angleBetween(neck, leftShoulder, leftElbow)             // 45°
        let RightneckAngle = angleBetween(neck, rightShoulder, rightElbow)          // 45°
        let LeftlegAngle = angleBetween(leftHip, leftKnee, leftAnkle)               // 180°
        let RightlegAngle = angleBetween(rightHip, rightKnee, rightAnkle)           // 180°
        let rightElbowAngle = angleBetween(rightWrist, rightElbow, rightShoulder)   // 90°
 
        // Tolerance ±40°
        let leftElbowOK = (leftElbowAngle > 70 && leftElbowAngle <= 110)
        let LeftNeckOK = (LeftneckAngle > 25 && LeftneckAngle < 65)
        let RightNeckOK = (RightneckAngle > 25 && RightneckAngle < 65)
        let LeftlegAngleOK = (LeftlegAngle > 140 && LeftlegAngle <= 180)
        let RightlegAngleOK = (RightlegAngle > 140 && RightlegAngle <= 180)
        let rightElbowOK = (rightElbowAngle > 70 && rightElbowAngle <= 110)
        
        // Print individual checks
        leftElbowOK ? print("No issue with left elbow") : print("Check left elbow: \(leftElbowAngle)°")
        LeftNeckOK ? print("No issue with left neck") : print("Check left neck: \(LeftneckAngle)°")
        RightNeckOK ? print("No issue with right neck") : print("Check left neck: \(RightneckAngle)°")
        RightlegAngleOK ? print("No issue with right leg") : print("Check right leg: \(RightlegAngle)°")
        LeftlegAngleOK ? print("No issue with left leg") : print("Check left leg: \(LeftlegAngle)°")
        rightElbowOK ? print("No issue with right elbow") : print("Check right elbow: \(rightElbowAngle)°")
        
        if leftElbowOK && LeftNeckOK && RightNeckOK && rightElbowOK && LeftlegAngleOK && RightlegAngleOK{
            print("Superhero pose DETECTED")
            return 4
        }
        return nil
    }
    
    func PoseCheck(observation: HumanBodyPoseObservation) -> Int {
        var Pose1Detected = PoseCheck1(observation: observation)
        var Pose2Detected = PoseCheck2(observation: observation)
        var Pose3Detected = PoseCheck3(observation: observation)
        var Pose4Detected = PoseCheck4(observation: observation)
        if Pose1Detected != nil{
            return 1
        } else if Pose2Detected != nil {
            return 2
        } else if Pose3Detected != nil {
            return 3
        } else if Pose4Detected != nil {
            return 4
        }
        return 0
    }
}



