//
//  Note.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 13.01.2023.
//

import UIKit

struct Note: Codable {
    let title: String
    let text: String

    static func makeMockNote() -> Note {
        Note(title: "Связанность кода",
             text: "Если ваш код связан или у вас есть один объект, который занимается вообще всем, то любое изменение в работе программы будет даваться с трудом. Поэтому слабая связанность кода — это хорошо! Это то, к чему стоит постоянно стремиться.")
    }
}
