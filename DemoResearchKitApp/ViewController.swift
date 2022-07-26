//
//  ViewController.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    var captureDate: String = "##########"
    var nameVar: String = "##########"
    var qualificationVar: String = "##########"
    var adventureTypeVar: String = "##########"
    var signatureTypeVar: String = "##########"
    
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
          taskViewController.outputDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
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
                    
                    //NAME STEP
                    if result.identifier == "QuestionStep" {
                        let nameResult = result as? ORKQuestionResult
                        if let user = nameResult?.answer {
                            jsonDict["name"] = user
                        } else {
                            jsonDict["name"] = nameVar
                        }
                    }
                    
                    //QUALIFICATION STEP
                    if result.identifier == "TextChoiceQuestionStep" {
                        let qualificationResult = result as? ORKQuestionResult
                        if let qualificationRes = qualificationResult?.answer {
                            let x = qualificationRes as! [Int]
                            let qualification = x.first!
                            
                            if qualification == 0 {
                                jsonDict["qualification"] = "Diploma"
                            }
                            else if qualification == 1 {
                                jsonDict["qualification"] = "Graduation"
                            }
                            else {
                                jsonDict["qualification"] = "Post Graduation"
                            }
                            
                        } else {
                            jsonDict["qualification"] = qualificationVar
                        }
                    }
                    
                    //IMAGE STEP
                    if result.identifier == "ImageChoiceQuestionStep" {
                        let imageChoiceResult = result as? ORKQuestionResult
                        if let choiceImage = imageChoiceResult?.answer {
                            let x = choiceImage as! [String]
                            let choice = x.first!
                            jsonDict["adventureType"] = choice
                        } else {
                            jsonDict["adventureType"] = adventureTypeVar
                        }
                    }
                    
                    //SIGNATURE STEP
                    if result.identifier == "SignatureStepForSurvey" {
                        print("hellotherejson")
                        
                        let signatureResult = result as? ORKSignatureResult
                        if let signature = signatureResult?.signatureImage {
                            let imageData = signature.pngData()!
                            let signatureString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                            jsonDict["signature"] = signatureString
                        } else {
                            jsonDict["signature"] = signatureTypeVar
                        }
                    }
//                    if result.identifier == "AudioRecordStepInSurvey" {
//                        let audioResult = result as? ORKAudioRecorder
//                        if let audioRecord = audioResult?.audioRecorder{
//
//                        }
//                    }
//                    if result.identifier == "ImageCaptureStepInSurvey" {
//                        let imageResult = result as? ORKImageCaptureStep
//                        let image = imageResult?.image
//                    }
                        
                }
            }
                jsonArrayTop.append(jsonDict)
            
            
            
            
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArrayTop, options: .prettyPrinted)
                
                let fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                
                let jsonURL = fileManager.first?.appendingPathComponent("researchKit.json")
                
                print("PathOfJSONFile: \(jsonURL)")
                
                try jsonData.write(to: jsonURL!)
            
                
            }
            catch {
                print(error)
            }
            
            
        default: break
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }

    

}


