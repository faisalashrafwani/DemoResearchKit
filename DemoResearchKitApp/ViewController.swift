//
//  ViewController.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    var captureDate: String = "####"
    var nameVar: String = "####"
    var qualificationVar: String = "####"
    var advantureTypeVar: String = "####"
    
    var jsonArrayTop: [Any] = []
    var jsonDict: [String : Any] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        let testImg = UIImage(named: "baloonride")
//        let imageDatum = testImg?.pngData()!
//        let chkImg = imageDatum?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//        print("loadimage: \(chkImg)!")
        
        
    }
    
    func dateTimeCapture() -> String{
        let formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "PM"
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.locale = Locale(identifier: "en_IN")
        formatter.dateFormat = "EEEE, MM/dd/yyyy, h:mm:ss a"
        return (formatter.string(from: Date()))
    }
    
    
    @IBAction func surveyTapped(_ sender: Any) {
        //Capturing date time on tapping survey button.
        captureDate = dateTimeCapture()
        
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
          taskViewController.delegate = self
          taskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! String, isDirectory: true)
          present(taskViewController, animated: true, completion: nil)
    }
    
}


extension ViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch reason {
        case .saved, .completed:
            
            let taskResults = taskViewController.result.results
            jsonDict["dateTimeCapture"] = captureDate
            for stepResults in taskResults! as! [ORKStepResult]{
                for result in stepResults.results! {
                    if result.identifier == "QuestionStep" {
                        let nameResult = result as? ORKQuestionResult
                        if let user = nameResult?.answer {
                            //nameVar = String(describing: user)
                            jsonDict["name"] = user
                        }
                    }
                    if result.identifier == "TextChoiceQuestionStep" {
                        let qualificationResult = result as? ORKQuestionResult
                        if let data = qualificationResult?.answer {
                            let test = String(describing: data)
                            print("testinghere \(test)")
                            let qualification = Int(test)
                            print("insideapplied \(qualification)")
                            if qualification == 1 {
                                print("appliedinfo")
                            }
                            //qualificationVar = String(describing: qualification)
                            jsonDict["qualification"] = qualification
                        }
                    }
                    if result.identifier == "ImageChoiceQuestionStep" {
                        let imageChoiceResult = result as? ORKQuestionResult
                        if let choiceImage = imageChoiceResult?.answer {
                            //advantureTypeVar = String(describing: choiceImage)
                            jsonDict["adventureType"] = choiceImage
                        }
                    }
                    
//                    if result.identifier == "SignatureCaptureStepInSurvey" {
//                        let signatureResult = result as? ORKSignatureResult
//                        if let signature = signatureResult?.signatureImage {
//                            let imageData = signature.pngData()!
//                            let datum = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//                          //  print("signhere: \(datum)")
//                            obj.signCapture = String(describing: datum)
//                        }
//                    }
//                    if result.identifier == "AudioRecordStepInSurvey" {
//                        let audioResult = result as?
//                    }
//                    if result.identifier == "ImageCaptureStepInSurvey" {
//                        let imageResult = result as? ORKImageCaptureStep
//                        let image = imageResult?.image
//                    }
                        
                }
                
                //jsonArrayTop.append(jsonDict)
            }
                jsonArrayTop.append(jsonDict)
            
            
            
            
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArrayTop, options: .prettyPrinted)
                
                let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                
                let jsonURL = fileManager.first?.appendingPathComponent("researchKit.json")
                
                print("applejson \(jsonURL)")
                
                try jsonData.write(to: jsonURL!)
            
                
            }
            catch {
                print(error)
            }
                
            //let roughResult = taskViewController.result.stepResult(forStepIdentifier: "stepIdentifier")?.results?.first as! ORKResult
            
            
        default: break
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }

    

}


