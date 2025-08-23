//
//  CameraView.swift
//  Challenge 2 App
//
//  Created by Dessen Tan on 16/8/25.
//


import SwiftUI
import AVFoundation
import CoreML
import Vision

struct CameraView: View {
   @ObservedObject var camera: CameraModel
   
   var body: some View {
       VStack{
           ZStack {
               CameraPreview(camera: camera)
                   .ignoresSafeArea(.all, edges: .all)
           }
           // Display prediction
           ScrollView {
                           VStack(alignment: .leading) {
                               ForEach(camera.predictions, id: \.self) { prediction in
                                   Text(prediction)
                                       .font(.headline)
                                       .padding(.bottom, 2)
                               }
                           }
                       }
       }
       .onAppear {
           camera.Check() // Start the camera when the view appears
       }
       .alert(isPresented: $camera.alert) {
           Alert(title: Text("Camera Access Denied"), message: Text("Please enable camera access in your settings."), dismissButton: .default(Text("OK")))
       }
   }
}

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
   @Published var session = AVCaptureSession()
   @Published var alert = false
   @Published var preview: AVCaptureVideoPreviewLayer!
   @Published var predictions: [String] = []
   
   private let model: VNCoreMLModel
   private let videoOutput = AVCaptureVideoDataOutput()

   override init() {
       // Load the Core ML model (replace YourModel with the actual model name)
       self.model = try! VNCoreMLModel(for: test().model)
       
       super.init()
       
       DispatchQueue.global(qos: .background).async {
           self.Check() // Check for camera authorization when the model is initialized
       }
   }
   
   func Check() {
       switch AVCaptureDevice.authorizationStatus(for: .video) {
       case .authorized:
           setUp() // If authorized, set up the session
       case .notDetermined:
           AVCaptureDevice.requestAccess(for: .video) { status in
               if status {
                   DispatchQueue.main.async {
                       self.setUp()
                   }
               }
           }
       case .denied:
           DispatchQueue.main.async {
               self.alert.toggle() // Show alert if access is denied
           }
       default:
           break
       }
   }
   
   func setUp() {
       DispatchQueue.global(qos: .background).async {
           do {
               // Begin configuration
               self.session.beginConfiguration()
               
               // Set up camera input
               let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
               if let device = device {
                   let input = try AVCaptureDeviceInput(device: device)
                   
                   // Add input
                   if self.session.canAddInput(input) {
                       self.session.addInput(input)
                   }
               }
               
               // Set up video output to capture frames
               self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
               self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
               
               // Add video output
               if self.session.canAddOutput(self.videoOutput) {
                   self.session.addOutput(self.videoOutput)
               }
               
               // Commit configuration changes
               self.session.commitConfiguration()
               
           } catch {
               print("Error setting up camera: \(error.localizedDescription)")
           }
       }
   }
   
   // Capture frame and make a prediction
   func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
           guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
           
           // Create a request to classify the frame
           let request = VNCoreMLRequest(model: model) { request, error in
               if let results = request.results as? [VNClassificationObservation] {
                   DispatchQueue.main.async {
                       // Format and store all results in the predictions array
                       self.predictions = results.map { result in
                           let confidence = String(format: "%.3f", result.confidence * 100) // Confidence in percentage
                           return "\(result.identifier): \(confidence)%"
                       }
                   }
               }
           }
           
           // Perform the request
           let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
           try? handler.perform([request])
       }
}

struct CameraPreview: UIViewRepresentable {
   @ObservedObject var camera: CameraModel
   
   func makeUIView(context: Context) -> UIView {
       let view = UIView(frame: UIScreen.main.bounds)
       
       // Setup camera preview
       camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
       camera.preview.frame = view.bounds
       camera.preview.videoGravity = .resizeAspectFill
       view.layer.addSublayer(camera.preview)
       
       camera.session.startRunning()
       
       return view
   }
   
   func updateUIView(_ uiView: UIView, context: Context) {
       // No need to update the view, since it's just showing the camera feed
   }
}
