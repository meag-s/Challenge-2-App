//
//  ContentView.swift
//  HumanBodyPoseRequest
//
//  Created by Matteo Altobello
//


import SwiftUI
import Vision
import AVFoundation
import Observation

struct GameView: View {
    @State var cameraViewModel = CameraViewModel()
    @State private var poseViewModel = PoseEstimationViewModel()
    @State var isPoseDetected = false
    var body: some View {
        NavigationStack{
            ZStack {
                
                CameraPreviewView(session: cameraViewModel.session)
                    .edgesIgnoringSafeArea(.all)
                
                PoseOverlayView(
                    bodyParts: poseViewModel.detectedBodyParts,
                    connections: poseViewModel.bodyConnections, isPoseDetected: $isPoseDetected
                )
                VStack {
                    CountdownCameraView() // now floating at top
                    Spacer()
                }
                
                
                
                if poseViewModel.PoseDetected == 1 {
                    Text("Fruity pose detected")
                } else if poseViewModel.PoseDetected == 2 {
                    Text("Victory pose Detected")
                } else if poseViewModel.PoseDetected == 3 {
                    Text("T-pose Detected")
                } else if poseViewModel.PoseDetected == 4 {
                    Text("Superhero Pose Detected")
                } else {
                    Text("Nothing detected")
                }
                
            }
            .task {
                await cameraViewModel.checkPermission()
                cameraViewModel.delegate = poseViewModel
            }
        }
    }
}

/*
 
 import SwiftUI
 import AVFoundation
 import Vision
 
 // MARK: - ContentView
 struct ContentView: View {
 @StateObject private var cameraViewModel = CameraViewModel()
 @StateObject private var poseViewModel = PoseEstimationViewModel()
 
 var body: some View {
 ZStack {
 CameraPreviewView(session: cameraViewModel.session)
 .edgesIgnoringSafeArea(.all)
 
 PoseOverlayView(
 bodyParts: poseViewModel.detectedBodyParts,
 connections: poseViewModel.bodyConnections
 )
 
 VStack {
 Spacer()
 Text("Detected body parts: \(poseViewModel.detectedBodyParts.count)")
 .padding()
 .background(Color.black.opacity(0.7))
 .foregroundColor(.white)
 .cornerRadius(8)
 .padding(.bottom)
 }
 }
 .onAppear {
 cameraViewModel.checkPermission()
 cameraViewModel.delegate = poseViewModel
 }
 }
 }
 
 // MARK: - Pose Overlay View
 struct PoseOverlayView: View {
 let bodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint]
 let connections: [BodyConnection]
 
 var body: some View {
 GeometryReader { geometry in
 ZStack {
 ForEach(connections) { connection in
 if let fromPoint = bodyParts[connection.from],
 let toPoint = bodyParts[connection.to] {
 Path { path in
 let fromPointInView = CGPoint(
 x: fromPoint.x * geometry.size.width,
 y: fromPoint.y * geometry.size.height
 )
 let toPointInView = CGPoint(
 x: toPoint.x * geometry.size.width,
 y: toPoint.y * geometry.size.height
 )
 
 path.move(to: fromPointInView)
 path.addLine(to: toPointInView)
 }
 .stroke(Color.green, lineWidth: 3)
 }
 }
 
 ForEach(Array(bodyParts.keys), id: \..self) { jointName in
 if let point = bodyParts[jointName] {
 let pointInView = CGPoint(
 x: point.x * geometry.size.width,
 y: point.y * geometry.size.height
 )
 
 Circle()
 .fill(getColorForJoint(jointName))
 .frame(width: 10, height: 10)
 .position(pointInView)
 .overlay(
 Circle()
 .stroke(Color.white, lineWidth: 1)
 .frame(width: 12, height: 12)
 )
 }
 }
 }
 }
 }
 
 private func getColorForJoint(_ joint: VNHumanBodyPoseObservation.JointName) -> Color {
 switch joint {
 case .nose, .leftEye, .rightEye, .leftEar, .rightEar:
 return .yellow
 case .neck, .leftShoulder, .rightShoulder, .leftHip, .rightHip:
 return .blue
 case .leftElbow, .rightElbow, .leftWrist, .rightWrist:
 return .red
 case .leftKnee, .rightKnee, .leftAnkle, .rightAnkle:
 return .purple
 default:
 return .orange
 }
 }
 }
 
 
 import SwiftUI
 import UIKit
 import AVFoundation
 
 // MARK: - Camera Preview View
 struct CameraPreviewView: UIViewRepresentable {
 let session: AVCaptureSession
 
 func makeUIView(context: Context) -> UIView {
 let view = UIView(frame: .zero)
 let previewLayer = AVCaptureVideoPreviewLayer(session: session)
 
 previewLayer.videoGravity = .resizeAspectFill
 previewLayer.frame = view.bounds
 previewLayer.connection?.videoRotationAngle = 0
 view.layer.addSublayer(previewLayer)
 
 return view
 }
 
 func updateUIView(_ uiView: UIView, context: Context) {
 Task {
 if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
 previewLayer.frame = uiView.bounds
 }
 }
 }
 }
 
 // MARK: - Camera ViewModel
 class CameraViewModel: NSObject, ObservableObject {
 let session = AVCaptureSession()
 private let sessionQueue = DispatchQueue(label: "sessionQueue")
 private let videoDataOutputQueue = DispatchQueue(label: "videoDataOutputQueue")
 private let videoDataOutput = AVCaptureVideoDataOutput()
 weak var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
 
 
 
 func checkPermission() {
 switch AVCaptureDevice.authorizationStatus(for: .video) {
 case .authorized:
 self.setupCamera()
 case .notDetermined:
 AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
 if granted {
 DispatchQueue.main.async {
 self?.setupCamera()
 }
 }
 }
 default:
 print("Camera permission denied")
 }
 }
 
 private func setupCamera() {
 sessionQueue.async { [weak self] in
 guard let self = self else { return }
 self.session.beginConfiguration()
 
 guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
 let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
 print("Failed to create video input")
 self.session.commitConfiguration()
 return
 }
 
 if self.session.canAddInput(videoInput) {
 self.session.addInput(videoInput)
 }
 
 self.videoDataOutput.videoSettings = [
 kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
 ]
 
 self.videoDataOutput.setSampleBufferDelegate(self.delegate, queue: self.videoDataOutputQueue)
 self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
 
 if self.session.canAddOutput(self.videoDataOutput) {
 self.session.addOutput(self.videoDataOutput)
 }
 
 if let connection = self.videoDataOutput.connection(with: .video) {
 connection.videoRotationAngle = 0
 connection.isVideoMirrored = true
 }
 
 self.session.commitConfiguration()
 self.session.startRunning()
 }
 }
 }
 
 
 import SwiftUI
 import Vision
 import AVFoundation
 
 
 // 1.
 struct BodyConnection: Identifiable {
 let id = UUID()
 let from: VNHumanBodyPoseObservation.JointName
 let to: VNHumanBodyPoseObservation.JointName
 }
 
 
 // MARK: - Pose Estimation ViewModel
 
 class PoseEstimationViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
 @Published var detectedBodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
 @Published var bodyConnections: [BodyConnection] = []
 
 override init() {
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
 guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
 let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .up)
 
 let poseRequest = VNDetectHumanBodyPoseRequest { [weak self] request, error in
 guard let self = self,
 let observations = request.results as? [VNHumanBodyPoseObservation],
 let observation = observations.first else { return }
 
 DispatchQueue.main.async {
 self.detectedBodyParts = self.extractPoints(from: observation)
 }
 }
 
 try? handler.perform([poseRequest])
 }
 
 private func extractPoints(from observation: VNHumanBodyPoseObservation) -> [VNHumanBodyPoseObservation.JointName: CGPoint] {
 var detectedPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
 for joint in bodyConnections.flatMap({ [$0.from, $0.to] }) {
 if let jointPoint = try? observation.recognizedPoint(joint), jointPoint.confidence > 0.3 {
 detectedPoints[joint] = CGPoint(x: jointPoint.x, y: 1 - jointPoint.y)
 }
 }
 return detectedPoints
 }
 }
 */





//import SwiftUI
//import AVFoundation
//import Vision
//
//struct ContentView: View {
//    @StateObject private var cameraViewModel = CameraViewModel()
//    @State private var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
//
//    var body: some View {
//        ZStack {
//            // Camera preview with integrated pose detection using UIViewRepresentable
//            CameraPreviewRepresentable(
//                cameraViewModel: cameraViewModel,
//                orientation: deviceOrientation
//            )
//            .edgesIgnoringSafeArea(.all)
//
//            // Pose overlay
//            PoseOverlayView(
//                bodyParts: cameraViewModel.detectedBodyParts,
//                connections: cameraViewModel.bodyConnections,
//                orientation: deviceOrientation
//            )
//
//            VStack {
//                Spacer()
//                Text("Detected body parts: \(cameraViewModel.detectedBodyParts.count)")
//                    .padding()
//                    .background(Color.black.opacity(0.7))
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                    .padding(.bottom)
//            }
//        }
//        .onAppear {
//            cameraViewModel.checkPermission()
//            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
//            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
//                deviceOrientation = UIDevice.current.orientation
//                cameraViewModel.updateOrientation(deviceOrientation)
//            }
//        }
//        .onDisappear {
//            UIDevice.current.endGeneratingDeviceOrientationNotifications()
//            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
//        }
//    }
//}
//
//// MARK: - CameraViewModel
//
//class CameraViewModel: NSObject, ObservableObject {
//    @Published var detectedBodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
//    @Published var bodyConnections: [BodyConnection] = []
//    @Published var currentOrientation: UIDeviceOrientation = .portrait
//
//    let session = AVCaptureSession()
//    private let sessionQueue = DispatchQueue(label: "sessionQueue")
//
//    struct BodyConnection {
//        let from: VNHumanBodyPoseObservation.JointName
//        let to: VNHumanBodyPoseObservation.JointName
//    }
//
//    override init() {
//        super.init()
//        setupBodyConnections()
//    }
//
//    func updateOrientation(_ orientation: UIDeviceOrientation) {
//        self.currentOrientation = orientation
//    }
//
//    private func setupBodyConnections() {
//        bodyConnections = [
//            // Head
//            BodyConnection(from: .nose, to: .neck),
//
//            // Torso
//            BodyConnection(from: .neck, to: .rightShoulder),
//            BodyConnection(from: .neck, to: .leftShoulder),
//            BodyConnection(from: .rightShoulder, to: .rightHip),
//            BodyConnection(from: .leftShoulder, to: .leftHip),
//            BodyConnection(from: .rightHip, to: .leftHip),
//
//            // Right arm
//            BodyConnection(from: .rightShoulder, to: .rightElbow),
//            BodyConnection(from: .rightElbow, to: .rightWrist),
//
//            // Left arm
//            BodyConnection(from: .leftShoulder, to: .leftElbow),
//            BodyConnection(from: .leftElbow, to: .leftWrist),
//
//            // Right leg
//            BodyConnection(from: .rightHip, to: .rightKnee),
//            BodyConnection(from: .rightKnee, to: .rightAnkle),
//
//            // Left leg
//            BodyConnection(from: .leftHip, to: .leftKnee),
//            BodyConnection(from: .leftKnee, to: .leftAnkle)
//        ]
//    }
//
//    func checkPermission() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            setupCamera()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//                if granted {
//                    DispatchQueue.main.async {
//                        self?.setupCamera()
//                    }
//                } else {
//                    print("Camera permission denied")
//                }
//            }
//        default:
//            print("Camera permission denied or restricted")
//        }
//    }
//
//    private func setupCamera() {
//        sessionQueue.async { [weak self] in
//            guard let self = self else { return }
//
//            self.session.beginConfiguration()
//            self.session.sessionPreset = .high
//
//            // Configure video input
//            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
//                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
//                print("Failed to create video input")
//                return
//            }
//            if self.session.canAddInput(videoInput) {
//                self.session.addInput(videoInput)
//            } else {
//                print("Could not add video input")
//            }
//
//            self.session.commitConfiguration()
//            self.session.startRunning()
//        }
//    }
//}
//
//// MARK: - Camera Preview View (UIViewRepresentable with Coordinator)
//struct CameraPreviewRepresentable: UIViewRepresentable {
//    @ObservedObject var cameraViewModel: CameraViewModel
//    var orientation: UIDeviceOrientation
//
//    func makeUIView(context: Context) -> UIView {
//        // Create a simple UIView that will host our AVCaptureVideoPreviewLayer
//        let view = UIView(frame: .zero)
//
//        // Create a preview layer and attach to the view
//        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraViewModel.session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.connection?.isVideoMirrored = true
//        view.layer.addSublayer(previewLayer)
//
//        // Set up video output with the coordinator as the delegate
//        let videoOutput = context.coordinator.videoOutput
//        if cameraViewModel.session.canAddOutput(videoOutput) {
//            cameraViewModel.session.addOutput(videoOutput)
//        }
//
//        // Initial orientation setup
//        context.coordinator.updateOrientation(orientation)
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update the preview layer's frame to match the view's bounds
//        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//            previewLayer.frame = uiView.bounds
//        }
//
//        // Update orientation in the coordinator
//        if context.coordinator.currentOrientation != orientation {
//            context.coordinator.updateOrientation(orientation)
//        }
//    }
//
//    // Create a coordinator to handle AVCaptureVideoDataOutput and pose detection
//    func makeCoordinator() -> Coordinator {
//        Coordinator(cameraViewModel: cameraViewModel)
//    }
//
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        var cameraViewModel: CameraViewModel
//        var videoOutput = AVCaptureVideoDataOutput()
//        var currentOrientation: UIDeviceOrientation = .portrait
//
//        init(cameraViewModel: CameraViewModel) {
//            self.cameraViewModel = cameraViewModel
//            super.init()
//            setupVideoOutput()
//        }
//
//        func updateOrientation(_ orientation: UIDeviceOrientation) {
//            self.currentOrientation = orientation
//        }
//
//        private func setupVideoOutput() {
//            videoOutput = AVCaptureVideoDataOutput()
//            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//            videoOutput.alwaysDiscardsLateVideoFrames = true
//
//            if let connection = videoOutput.connection(with: .video) {
//                connection.videoOrientation = .portrait
//            }
//        }
//
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            // Update connection orientation based on device orientation
//            switch currentOrientation {
//            case .landscapeLeft:
//                connection.videoOrientation = .landscapeRight
//            case .landscapeRight:
//                connection.videoOrientation = .landscapeLeft
//            case .portraitUpsideDown:
//                connection.videoOrientation = .portraitUpsideDown
//            default:
//                connection.videoOrientation = .portrait
//            }
//
//            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//            detectPose(in: imageBuffer)
//        }
//
//        private func getImageOrientation() -> CGImagePropertyOrientation {
//            switch currentOrientation {
//            case .landscapeLeft:
//                return .right
//            case .landscapeRight:
//                return .left
//            case .portraitUpsideDown:
//                return .down
//            default:
//                return .up
//            }
//        }
//
//        private func detectPose(in imageBuffer: CVImageBuffer) {
//            let poseRequest = VNDetectHumanBodyPoseRequest { [weak self] request, error in
//                guard let self = self,
//                      error == nil,
//                      let observations = request.results as? [VNHumanBodyPoseObservation],
//                      let observation = observations.first else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.processPoseObservation(observation)
//                }
//            }
//
//            let orientation = getImageOrientation()
//            let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: orientation)
//
//            do {
//                try handler.perform([poseRequest])
//            } catch {
//                print("Failed to perform pose detection: \(error)")
//            }
//        }
//
//        private func processPoseObservation(_ observation: VNHumanBodyPoseObservation) {
//            var detectedPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
//            let jointNames: [VNHumanBodyPoseObservation.JointName] = [
//                .nose, .leftEye, .rightEye, .leftEar, .rightEar,
//                .neck, .leftShoulder, .rightShoulder,
//                .leftElbow, .rightElbow,
//                .leftWrist, .rightWrist,
//                .leftHip, .rightHip,
//                .leftKnee, .rightKnee,
//                .leftAnkle, .rightAnkle
//            ]
//
//            for jointName in jointNames {
//                do {
//                    let jointPoint = try observation.recognizedPoint(jointName)
//                    if jointPoint.confidence > 0.3 {
//                        // Normalize and flip the y-axis
//                        let point = CGPoint(x: jointPoint.x, y: 1 - jointPoint.y)
//                        detectedPoints[jointName] = point
//                    }
//                } catch {
//                    continue
//                }
//            }
//
//            // Update the ViewModel with new body parts data
//            DispatchQueue.main.async {
//                self.cameraViewModel.detectedBodyParts = detectedPoints
//            }
//        }
//    }
//}
//
//// MARK: - Pose Overlay View
//
//struct PoseOverlayView: View {
//    let bodyParts: [VNHumanBodyPoseObservation.JointName: CGPoint]
//    let connections: [CameraViewModel.BodyConnection]
//    let orientation: UIDeviceOrientation
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Draw connections between joints
//                ForEach(0..<connections.count, id: \.self) { i in
//                    let connection = connections[i]
//                    if let fromPoint = bodyParts[connection.from],
//                       let toPoint = bodyParts[connection.to] {
//                        Path { path in
//                            let adjustedFromPoint = adjustPointForOrientation(fromPoint, size: geometry.size)
//                            let adjustedToPoint = adjustPointForOrientation(toPoint, size: geometry.size)
//                            path.move(to: adjustedFromPoint)
//                            path.addLine(to: adjustedToPoint)
//                        }
//                        .stroke(Color.green, lineWidth: 3)
//                    }
//                }
//                // Draw joints as circles
//                ForEach(Array(bodyParts.keys), id: \.self) { jointName in
//                    if let point = bodyParts[jointName] {
//                        let adjustedPoint = adjustPointForOrientation(point, size: geometry.size)
//                        Circle()
//                            .fill(getColorForJoint(jointName))
//                            .frame(width: 10, height: 10)
//                            .position(adjustedPoint)
//                            .overlay(
//                                Circle()
//                                    .stroke(Color.white, lineWidth: 1)
//                                    .frame(width: 12, height: 12)
//                            )
//                    }
//                }
//            }
//        }
//    }
//
//    // Adjust the normalized point based on current device orientation and view size.
//    private func adjustPointForOrientation(_ point: CGPoint, size: CGSize) -> CGPoint {
//        let flippedPoint = CGPoint(x: 1 - point.x, y: point.y)
//        switch orientation {
//        case .landscapeLeft:
//            return CGPoint(x: flippedPoint.y * size.width, y: flippedPoint.x * size.height)
//        case .landscapeRight:
//            return CGPoint(x: (1 - flippedPoint.y) * size.width, y: (1 - flippedPoint.x) * size.height)
//        case .portraitUpsideDown:
//            return CGPoint(x: (1 - flippedPoint.x) * size.width, y: (1 - flippedPoint.y) * size.height)
//        default:
//            return CGPoint(x: flippedPoint.x * size.width, y: flippedPoint.y * size.height)
//        }
//    }
//
//    // Assign colors based on body region.
//    private func getColorForJoint(_ joint: VNHumanBodyPoseObservation.JointName) -> Color {
//        switch joint {
//        case .nose, .leftEye, .rightEye, .leftEar, .rightEar:
//            return .yellow    // Head
//        case .neck, .leftShoulder, .rightShoulder, .leftHip, .rightHip:
//            return .blue      // Torso
//        case .leftElbow, .rightElbow, .leftWrist, .rightWrist:
//            return .red       // Arms
//        case .leftKnee, .rightKnee, .leftAnkle, .rightAnkle:
//            return .purple    // Legs
//        default:
//            return .orange
//        }
//    }
//}
//
//
