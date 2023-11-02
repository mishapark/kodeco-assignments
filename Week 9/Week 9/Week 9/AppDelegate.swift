//
//  AppDelegate.swift
//  Week 9
//
//  Created by Mikhail Pak on 2023-10-27.
//

import Foundation

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  var backgroundCompletionHandler: (() -> Void)?

  func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) {
    backgroundCompletionHandler = completionHandler
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(backgroundDidDownload),
                                           name: SearchStore.BackgroundDownloadDidFinish,
                                           object: nil)

    return true
  }

  @objc private func backgroundDidDownload() {
    if let backgroundCompletionHandler = backgroundCompletionHandler {
      backgroundCompletionHandler()
    }
  }
}
