//
//  SceneDelegate.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 10.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let notesListViewController = NotesListViewController()
        let navigationController = UINavigationController(rootViewController: notesListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
