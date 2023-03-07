//
//  GoogleAuth.swift
//  Kuramin
//
//  Created by Numan Bashir on 07/03/2023.
//

import Foundation
import GoogleSignIn

func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
  return GIDSignIn.sharedInstance.handle(url)
}
