//
//  ViewController.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    var defaultValue: String = "##########"
    
    var id: Int = 1
    
    var jsonArrayTop: [Any] = []
    var jsonDict: [String : Any] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        dateFormatter.locale = Locale(identifier: "en_US")
        print("date here: \((dateFormatter.string(from: Date())))")
        return (dateFormatter.string(from: Date()))
    }
    
    
    @IBAction func surveyTapped(_ sender: Any) {

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
            //FETCH RESULTS
            for stepResults in taskResults! as! [ORKStepResult]{
                for result in stepResults.results! {
                    
                    //NAME STEP
                    if result.identifier == "QuestionStep" {
                        let nameResult = result as? ORKQuestionResult
                        jsonDict["id"] = id
                        if let user = nameResult?.answer {
                            jsonDict["name"] = user
                        } else {
                            jsonDict["name"] = defaultValue
                        }
                        id += 1
                        jsonArrayTop.append(jsonDict)
                    }
                    
                    //QUALIFICATION STEP
                    if result.identifier == "TextChoiceQuestionStep" {
                        let qualificationResult = result as? ORKQuestionResult
                        jsonDict["id"] = id
                        if let qualificationRes = qualificationResult?.answer {
                            let x = qualificationRes as! [String]
                            let qualification = x.first!
                            jsonDict["qualification"] = qualification
                            
                        } else {
                            jsonDict["qualification"] = defaultValue
                        }
                        id += 1
                        jsonArrayTop.append(jsonDict)
                    }
                    
                    //IMAGE STEP
                    if result.identifier == "ImageChoiceQuestionStep" {
                        let imageChoiceResult = result as? ORKQuestionResult
                        jsonDict["id"] = id
                        if let choiceImage = imageChoiceResult?.answer {
                            let x = choiceImage as! [String]
                            let choice = x.first!
                            jsonDict["adventureType"] = choice
                            
                        } else {
                            jsonDict["adventureType"] = defaultValue
                        }
                        id += 1
                        jsonArrayTop.append(jsonDict)
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
                            jsonDict["signature"] = defaultValue
                        }
                    }
                    
                    
//                    if result.identifier == "AudioRecordStepInSurvey" {
//                        let audioResult = result as? ORKAudioRecorder
//                        if let audioRecord = audioResult?.audioRecorder{
//
//                        }
//                    }
//
//                    if result.identifier == "ImageCaptureStepInSurvey" {
//                        let imageResult = result as? ORKImageCaptureStep
//                        let image = imageResult?.image
//                    }
                        
                }
                jsonDict = [:]
            }
            jsonDict["id"] = id
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
                
                print("PathOfJSONFile: \(jsonURL!)")
                
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


