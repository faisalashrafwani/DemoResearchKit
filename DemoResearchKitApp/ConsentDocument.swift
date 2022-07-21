//
//  ConsentDocument.swift
//  DemoResearchKitApp
//
//  Created by Applied Informatics on 20/04/22.
//

import Foundation
import ResearchKit

public var ConsentDocument: ORKConsentDocument {
  
  let consentDocument = ORKConsentDocument()
  consentDocument.title = "Required Consent"
    
    let consentSectionTypes: [ORKConsentSectionType] = [
      .overview,
      .dataGathering,
      .privacy,
      .dataUse,
      .timeCommitment,
      .studySurvey,
      .studyTasks,
      .withdrawing
    ]
    
    
    
    //TODO: consent sections
    var consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
      let consentSection = ORKConsentSection(type: contentSectionType)
        switch contentSectionType {
        case .overview:
            consentSection.summary = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat turpis nisi, ac egestas sem suscipit eget. Duis id orci eget ex blandit sollicitudin eu in dui. Morbi euismod mollis nisi, a suscipit nulla tempor at. Maecenas ultrices, neque eu pulvinar eleifend, nibh ex elementum orci, nec imperdiet nisi risus in ante. Morbi aliquam vestibulum lacus consequat convallis. Etiam tincidunt venenatis orci, ut blandit nibh congue gravida. Curabitur ac augue vel massa finibus gravida. Donec tincidunt erat urna, a dignissim arcu tempus vel. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam varius sed lacus et iaculis. Duis pretium posuere ligula, at suscipit nibh aliquam eu. Integer gravida, erat a condimentum condimentum, ex mi tincidunt ex, quis faucibus nulla sapien quis risus. Mauris non tortor quis neque sodales pharetra a vel elit. Donec eget leo in orci tristique sollicitudin. Aliquam a pretium est. Quisque in accumsan mi. Praesent mattis commodo tellus, vitae vulputate orci rutrum sed. Maecenas sit amet dictum arcu. Donec efficitur vitae tortor ac pellentesque. Suspendisse in erat tristique, viverra libero id, elementum velit. Maecenas felis lectus, posuere eu ante eget, tincidunt cursus erat. In pellentesque, eros sit amet hendrerit dignissim, eros turpis iaculis orci, vel porttitor risus nisl et urna. Vestibulum fermentum lectus sit amet leo consequat, quis elementum ipsum viverra. Curabitur rutrum metus sed mi mattis convallis. Nullam tincidunt pulvinar feugiat. Mauris accumsan lobortis massa eget ultrices. Nam risus diam, sagittis sit amet lectus vel, porta accumsan lorem. Phasellus blandit mattis tristique. Vivamus malesuada efficitur ipsum, eu cursus erat vulputate a. Fusce sollicitudin est eu risus auctor porttitor. Vivamus in felis ac orci maximus porta porta in tortor. Cras aliquet orci massa, at bibendum elit rutrum non. Fusce accumsan, orci ac consectetur tincidunt, dui massa faucibus dui, quis semper felis metus in sapien. Nunc id placerat enim, a rhoncus metus."
            consentSection.content = "This is overview section content"
            break
        case .dataGathering:
            consentSection.summary = "This is the data gathering section."
            consentSection.content = "This is datagathering section content"
            break
        case .privacy:
            consentSection.summary = "This is the privacy section"
            consentSection.content = "This is privacy section content"
            break
        case .dataUse:
            consentSection.summary = "This is the data use section"
            consentSection.content = "This is data use section content"
            break
        case .timeCommitment:
            consentSection.summary = "This is the time commitment section"
            consentSection.content = "This is time commitment section content"
            break
        case .studySurvey:
            consentSection.summary = "This is the Study Survey section"
            consentSection.content = "This is Study Survey section content"
            break
        case .studyTasks:
            consentSection.summary = "This is the Study Tasks section"
            consentSection.content = "This is StudyTasks section content"
            break
        case .withdrawing:
            consentSection.summary = "This is the withdrawing section"
            consentSection.content = "This is withdrawing section content"
            break
        default:
            consentSection.summary = "This is the default section"
            consentSection.content = "This is default content"
            
        }
      return consentSection
    }

    consentDocument.sections = consentSections

  
  //TODO: signature
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))

  
  return consentDocument
}

