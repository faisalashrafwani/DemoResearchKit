//
//  ConsentTask.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {
  
  var steps = [ORKStep]()
  
  //TODO: Add VisualConsentStep
    var consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]

  
  //TODO: Add ConsentReviewStep
    let signature = consentDocument.signatures!.first as! ORKConsentSignature

    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)

    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"

    steps += [reviewConsentStep]

  
  return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}

