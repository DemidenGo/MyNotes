//
//  NotesKeychainStorage.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 31.03.2023.
//

import UIKit
import SwiftKeychainWrapper

protocol NotesStorageProtocol {
    func save(notes: [Note])
    func loadNotes() -> [Note]?
}

final class NotesKeychainStorage: NotesStorageProtocol {

    static let shared = NotesKeychainStorage()

    private enum Keys: String {
        case myNotes
    }

    private var notes: [Note]? {
        guard let encodedData = KeychainWrapper.standard.data(forKey: Keys.myNotes.rawValue) else {
            print("Error: unable to get notes from Kaychain storage")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let decodedNotes = try decoder.decode(Array<Note>.self, from: encodedData)
            return decodedNotes
        } catch {
            print("Error: unable to decode notes from data: \(error.localizedDescription)")
            return nil
        }
    }

    func save(notes: [Note]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(notes)
            KeychainWrapper.standard.set(encodedData, forKey: Keys.myNotes.rawValue)
        } catch {
            preconditionFailure("Unable to encode notes to data: \(error.localizedDescription)")
        }
    }

    func loadNotes() -> [Note]? {
        notes
    }
}
