//
//  ViewController.swift
//  HK Road Sign Detection
//
//  Created by Jason Chow on 11/5/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var result: UIButton!
    
//    var imageSize = CGSize()
//    var selectedImage = UIImage()
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest? = {
        do {
            let model = try VNCoreMLModel(for: ODJECT_DECTECTION_MLMODEL)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        result.titleLabel?.textAlignment = .center
        result.setTitle("Classifying...", for: .normal)
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest!])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.result.setTitle("Unable to classify image.\n\(error!.localizedDescription)", for: .normal)
                return
            }
            let classifications = results as! [VNRecognizedObjectObservation]
            if classifications.isEmpty {
                self.result.setAttributedTitle(NSMutableAttributedString(string: "Nothing recognized."), for: .normal)
            } else {
                var msg = "Road Sign Detected: \n \n"
                for classification in classifications {
                    var objectIdentifier = ""
                    var objectConfidence: Float = 0.0
                    self.addBoundingBoxOnImage(boundingBox: classification.boundingBox)
                    for label in classification.labels {
                        if objectConfidence.isLess(than: Float(label.confidence)) {
                            objectIdentifier = label.identifier
                            objectConfidence = label.confidence
                        }
                    }
                   msg += String(format: "(%.2f) %@ \n", objectConfidence, objectIdentifier)
                }
                self.result.setTitle(msg, for: .normal)
            }
        }
    }
    

    func addBoundingBoxOnImage(boundingBox: CGRect) {
        guard let image = self.imageView?.image else {
            return
        }
        
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)
        
        let rectangle = CGRect(x: boundingBox.minX*image.size.width, y: (1-boundingBox.minY-boundingBox.height)*image.size.height, width: boundingBox.width*image.size.width, height: boundingBox.height*image.size.height)
        UIColor(red: 0, green: 1, blue: 0, alpha: 0.4).setFill()
        UIRectFillUsingBlendMode(rectangle, CGBlendMode.normal)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.imageView?.image = newImage
        
    }
    
    // MARK: - Photo Actions
    @IBAction func takePicture(_ sender: Any) {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //For solve iPad UI Cannot show the pop up alert
        if let popoverController = photoSourcePicker.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        present(photoSourcePicker, animated: true)
    }
   

    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        updateClassifications(for: image)
    }
}


