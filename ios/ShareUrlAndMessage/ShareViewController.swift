//
//  ShareViewController.swift
//  ShareUrlAndMessage
//
//  Created by popy1017 on 2020/06/07.
//

import UIKit
import Social
import MobileCoreServices
import Foundation

struct Configuration {
    static let shared = Configuration()

    private let config: [AnyHashable: Any] = {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        return plist["AppConfig"] as! [AnyHashable: Any]
    }()

    let hostAppBundleIdentifier: String

    private init() {
        hostAppBundleIdentifier = config["HostAppBundleIdentifier"] as! String
    }
}

struct Payload : Codable{
    var url: String
    var message: String
}

class ShareViewController: SLComposeServiceViewController {

    let sharedKey = "ShareKey"
    var sharedText: [String] = []
    let imageContentType = kUTTypeImage as String
    let videoContentType = kUTTypeMovie as String
    let textContentType = kUTTypeText as String
    let urlContentType = kUTTypeURL as String
    let fileURLType = kUTTypeFileURL as String;
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if let contents = content.attachments {
                for (index, attachment) in (contents).enumerated() {
                    if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                        handleUrl(content: content, attachment: attachment, index: index)
                    }
                }
            }
        } else {
            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func handleUrl (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        print("handleUrl: group.\(Configuration.shared.hostAppBundleIdentifier)")
        print("contentText: \(self.contentText ?? "None")")
        
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in

            if error == nil, let item = data as? URL, let this = self {
                
                do {
                    let payload = Payload(url: item.absoluteString, message: (self?.contentText)!)
                    let payloadJson = try JSONEncoder().encode(payload)
                    let stringPayload = String(data: payloadJson, encoding: .utf8)

                    this.sharedText.append(stringPayload!)

                    // If this is the last item, save imagesData in userDefaults and redirect to host app
                    if index == (content.attachments?.count)! - 1 {
                        let userDefaults = UserDefaults(suiteName: "group.\(Configuration.shared.hostAppBundleIdentifier)")
                        userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                        userDefaults?.synchronize()
                        this.redirectToHostApp(type: .text)
                    }
                } catch {
                    print(error)
                    self?.dismissWithError()
                }
                
            } else {
                self?.dismissWithError()
            }
        }
    }
    
    private func dismissWithError() {
        print("[ERROR] Error loading data!")
        let alert = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)

        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    enum RedirectType {
        case media
        case text
        case file
    }

    private func redirectToHostApp(type: RedirectType) {
        let url = URL(string: "ShareMedia://dataUrl=\(sharedKey)#\(type)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")

        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
