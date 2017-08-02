//
//  ViewController.swift
//  MIDemo
//
//  Created by Prajeesh Prabhakar on 7/27/17.
//  Copyright © 2017 Prajeesh Prabhakar. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var mlResult: UILabel!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       activityIndicatior.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func handleCameraRoll(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePicked.image = pickedImage
            
            
            detactImageContent(image:pickedImage)
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func detactImageContent(image:UIImage){
        guard  let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model)else {
            fatalError("Failed to load model ")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Unexpected result")
            }
            
            guard let topResult = result.first else {
                fatalError("Unexpected result")
            }
            DispatchQueue.main.async {[weak self] in
                
                self?.mlResult.text = "\(topResult.identifier) with \(Int(topResult.confidence * 100))% in cofidence "
               self?.activityIndicatior.isHidden = true
                self?.activityIndicatior.stopAnimating()
                
            }
        }
        guard let ciImage =  CIImage(image:image ) else {
            fatalError("Can not convert image" )
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global().async {
            do {
                
                 DispatchQueue.main.async {[weak self] in
                self?.mlResult.text = ""
                self?.activityIndicatior.isHidden = false
                self?.activityIndicatior.startAnimating()
                
                }
                    
                    
                    
                    
                    
                    
                    
                    
                try handler.perform([request])
            
            }
            catch{
                
            }
        }
        
      
        
//        let request = VNCoreMLModel(model:model){
//            [weak self ] request ,error in
//            guard let result = request
//        }
    }
    
}

