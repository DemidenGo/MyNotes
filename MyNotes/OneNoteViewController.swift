//
//  NotesViewController.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 13.01.2023.
//

import UIKit

final class OneNoteViewController: UIViewController {

    var callback: ((Note) -> ())?
    var editableNote: Note?
    private var noteName: String?
    private var noteText: String?
    private lazy var note = Note(title: "", text: "")

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название заметки"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textField.makeIndent(points: 16)
        textField.delegate = self
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = .whileEditing
        textField.smartInsertDeleteType = .no
        return textField
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 16
        textView.layer.masksToBounds = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = "Введите текст заметки"
        textView.textColor = .systemGray3
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray3
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        return button
    }()

    private lazy var charactersLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        label.alpha = 0.0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        prepareForEdit()
        showEditableNote()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        eraseUserData()
        refreshViews()
    }

    private func showEditableNote() {
        guard let editableNote = editableNote else { return }
        noteName = editableNote.title
        noteText = editableNote.text
        textField.text = noteName
        textView.text = noteText
    }

    private func prepareForEdit() {
        if editableNote != nil {
            textView.textColor = .black
            doneButton.backgroundColor = .black
            doneButton.isUserInteractionEnabled = true
        }
    }

    @objc private func doneButtonAction() {
        guard let noteName = noteName, let noteText = noteText else { return }
        note = Note(title: noteName, text: noteText)
        navigationController?.popViewControllerWithHandler { [weak self] in
            guard let self = self else { return }
            self.callback?(self.note)
        }
        navigationController?.popViewController(animated: true)
    }

    private func eraseUserData() {
        noteName = nil
        noteText = nil
        note = Note(title: "", text: "")
        editableNote = nil
    }

    private func refreshViews() {
        textField.text = nil
        textView.text = "Введите текст заметки"
        textView.textColor = .systemGray3
        doneButton.backgroundColor = .systemGray3
        doneButton.isUserInteractionEnabled = false
    }

    private func setupController() {
        view.backgroundColor = .white
        hideKeyboardByTap()
    }

    private func setupConstraints() {
        [textField, textView, doneButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),

            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5),

            doneButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupCharactersLimitLabelConstraints() {
        guard !view.subviews.contains(where: { $0 == charactersLimitLabel }) else { return }
        view.addSubview(charactersLimitLabel)
        NSLayoutConstraint.activate([
            charactersLimitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6),
            charactersLimitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func showCharactersLimitLabel() {
        charactersLimitLabel.isHidden = false
        setupCharactersLimitLabelConstraints()
        charactersLimitLabel.animateAlpha(to: 1.0)
    }

    private func hideCharactersLimitLabel() {
        charactersLimitLabel.animateAlpha(to: 0.0) { [weak self] in
            self?.charactersLimitLabel.isHidden = true
        }
    }

    private func activateCreateButton() {
        guard noteName != nil && noteText != nil else { return }
        doneButton.backgroundColor = .black
        doneButton.isUserInteractionEnabled = true
    }

    private func deactivateCreateButton() {
        guard noteName == nil || noteText == nil else { return }
        doneButton.backgroundColor = .systemGray3
        doneButton.isUserInteractionEnabled = false
    }
}

// MARK: - UITextFieldDelegate

extension OneNoteViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideCharactersLimitLabel()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newNoteName = textField.text, newNoteName != "" else {
            self.noteName = nil
            deactivateCreateButton()
            return
        }
        self.noteName = newNoteName
        activateCreateButton()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharactersCount = textField.text?.count ?? 0
        let newLength = currentCharactersCount + string.count - range.length
        if newLength > 38, charactersLimitLabel.isHidden { showCharactersLimitLabel() }
        if newLength <= 38, !charactersLimitLabel.isHidden { hideCharactersLimitLabel() }
        return newLength <= 38
    }
}

// MARK: - UITextViewDelegate

extension OneNoteViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введите текст заметки"
            textView.textColor = .systemGray3
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            noteText = nil
            deactivateCreateButton()
            return
        }
        noteText = textView.text
        activateCreateButton()
    }
}
