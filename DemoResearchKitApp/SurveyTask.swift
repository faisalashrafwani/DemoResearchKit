//
//  SurveyTask.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
  var steps = [ORKStep]()
    
  
  //TODO: add instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Three Question Survey"
    instructionStep.text = "Please answer three questions."
    steps += [instructionStep]

  
  //TODO: add name question
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    steps += [nameQuestionStep]

  
  //TODO: add 'what is your quest' question
    let questQuestionStepTitle = "What is your Qualification?"
    let textChoices = [
      ORKTextChoice(text: "Diploma", value: 0 as NSNumber),
      ORKTextChoice(text: "Graduation", value: 1 as NSNumber),
      ORKTextChoice(text: "Post graduation", value: 2 as NSNumber)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps += [questQuestionStep]
  
  //TODO: add color question step
    let colorQuestionStepTitle = "What is your favorite adventure?"
    let colorTuples = [
//      (UIImage(named: "red")!, "Red"),
//      (UIImage(named: "orange")!, "Orange"),
//      (UIImage(named: "yellow")!, "Yellow"),
//      (UIImage(named: "green")!, "Green"),
//      (UIImage(named: "blue")!, "Blue"),
//      (UIImage(named: "purple")!, "Purple"),
      
      
      (UIImage(named: "hiking")!, "Hiking"),
      (UIImage(named: "baloonride")!, "Baloon Ride")
//      (UIImage(named: "swimming")!, "Swimming"),
//      (UIImage(named: "rafting")!, "Rafting"),
//      (UIImage(named: "skydiving")!, "Sky diving"),
//      (UIImage(named: "waterskiing")!, "Water Skiing")
      
    ]
    let imageChoices : [ORKImageChoice] = colorTuples.map {
      return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1 as NSString)
    }
    let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
    let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
    steps += [colorQuestionStep]

  
  //TODO: add summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "Thank You."
    steps += [summaryStep]

  
  return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}

