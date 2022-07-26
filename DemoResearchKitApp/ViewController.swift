//
//  ViewController.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
//    var captureDateLocal: String = "##########"
//    var captureDateUTC: String = "##########"
    var nameVar: String = "##########"
    var qualificationVar: String = "##########"
    var adventureTypeVar: String = "##########"
    var signatureTypeVar: String = "##########"
    
    var id: Int = 1
    
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
    
    func dateTimeCaptureLocal() -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH: mm: ssZ"
        return (formatter.string(from: Date()))
    }
    func dateTimeCaptureUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH: mm: ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "UTC")
        return (dateFormatter.string(from: Date()))
    }
    
    
    @IBAction func surveyTapped(_ sender: Any) {
        //Capturing date time on tapping survey button.
//        captureDateLocal = dateTimeCaptureLocal()
//        captureDateUTC = dateTimeCaptureUTC()
        

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
            //jsonDict["dateTimeCapture"] = captureDate
            
            for stepResults in taskResults! as! [ORKStepResult]{
                for result in stepResults.results! {
                    
                    //NAME STEP
                    if result.identifier == "QuestionStep" {
                        let nameResult = result as? ORKQuestionResult
                        if let user = nameResult?.answer {
                            jsonDict["id"] = id
                            jsonDict["name"] = user
                            id += 1
                        } else {
                            jsonDict["id"] = id
                            jsonDict["name"] = nameVar
                            id += 1
                        }
                        jsonArrayTop.append(jsonDict)
                        jsonDict = [:]
                    }
                    
                    //QUALIFICATION STEP
                    if result.identifier == "TextChoiceQuestionStep" {
                        let qualificationResult = result as? ORKQuestionResult
                        if let qualificationRes = qualificationResult?.answer {
                            let x = qualificationRes as! [Int]
                            let qualification = x.first!
                            
                            if qualification == 0 {
                                jsonDict["id"] = id
                                jsonDict["qualification"] = "Diploma"
                                id += 1
                            }
                            else if qualification == 1 {
                                jsonDict["id"] = id
                                jsonDict["qualification"] = "Graduation"
                                id += 1
                            }
                            else {
                                jsonDict["id"] = id
                                jsonDict["qualification"] = "Post Graduation"
                                id += 1
                            }
                            
                        } else {
                            jsonDict["id"] = id
                            jsonDict["qualification"] = qualificationVar
                            id += 1
                        }
                        jsonArrayTop.append(jsonDict)
                        jsonDict = [:]
                    }
                    
                    //IMAGE STEP
                    if result.identifier == "ImageChoiceQuestionStep" {
                        let imageChoiceResult = result as? ORKQuestionResult
                        if let choiceImage = imageChoiceResult?.answer {
                            let x = choiceImage as! [String]
                            let choice = x.first!

                            jsonDict["id"] = id
                            jsonDict["adventureType"] = choice
                            id += 1
                            
                        } else {
                            jsonDict["id"] = id
                            jsonDict["adventureType"] = adventureTypeVar
                            id += 1
                        }
                        jsonArrayTop.append(jsonDict)
                        jsonDict = [:]
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
            
            jsonDict["id"] = id; id += 1
            jsonDict["timeCaptureLocal"] = dateTimeCaptureLocal()
            jsonDict["timeCaptureUTC"] = dateTimeCaptureUTC()
            jsonArrayTop.append(jsonDict)
            jsonDict = [:]
            id = 1
            
            //CREATION OF JSON FILE
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


