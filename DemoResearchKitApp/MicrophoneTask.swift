//
//  MicrophoneTask.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import Foundation
import ResearchKit

public var MicrophoneTask: ORKOrderedTask {
    return ORKOrderedTask.audioTask(withIdentifier: "AudioTask", intendedUseDescription: "A sentence prompt will be given to you to read.", speechInstruction: "Please speak loud and clear for the next 10 seconds", shortSpeechInstruction: "This is a voice test. I am supposed to speak for ten seconds.", duration: 10, recordingSettings: nil, checkAudioLevel: false, options: ORKPredefinedTaskOption.excludeAccelerometer)
}

