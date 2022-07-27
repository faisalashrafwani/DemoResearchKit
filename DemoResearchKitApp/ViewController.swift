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
    
    final let timestampId: Int = 4

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
                    if result.identifier == "1" {
                        let nameResult = result as? ORKQuestionResult
                        jsonDict["id"] = Int(result.identifier)
                        jsonDict["name"] = nameResult?.answer ?? defaultValue
                        jsonArrayTop.append(jsonDict)
                    }
                    
                    //QUALIFICATION STEP
                    if result.identifier == "2" {
                        let qualificationResult = result as? ORKQuestionResult
                        jsonDict["id"] = Int(result.identifier)
                        let qualificationRes = qualificationResult?.answer as? [String] ?? [defaultValue]
                        let qualification = qualificationRes.first!
                        jsonDict["qualification"] = qualification
                        jsonArrayTop.append(jsonDict)
                    }
                    
                    //ADVENTURE STEP
                    if result.identifier == "3" {
                        let imageChoiceResult = result as? ORKQuestionResult
                        jsonDict["id"] = Int(result.identifier)
                        let choiceImageRes = imageChoiceResult?.answer as? [String] ?? [defaultValue]
                        let choice = choiceImageRes.first
                        jsonDict["adventureType"] = choice
                        jsonArrayTop.append(jsonDict)
                    }
                    
                    //SIGNATURE STEP
                    if result.identifier == "4" {
                        print("hellotherejson")

                        let signatureResult = result as? ORKSignatureResult
                        jsonDict["id"] = Int(result.identifier)
                        let signature = signatureResult?.signatureImage ?? UIImage(named:"baloonride")
                        let imageData = signature!.pngData()!
                        let signatureString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                        jsonDict["signature"] = signatureString
                        
                    }
                    
//                    if result.identifier == "5" {
//
//                    }
//
//                    if result.identifier == "6" {
//
//                    }
                }
                jsonDict = [:]
            }
            jsonDict["id"] = timestampId
            jsonDict["timeCaptureLocal"] = dateTimeCaptureLocal()
            jsonDict["timeCaptureUTC"] = dateTimeCaptureUTC()
            jsonArrayTop.append(jsonDict)
            jsonDict = [:]
            
            
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
