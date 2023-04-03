//
//  ViewController.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 10.01.2023.
//

import UIKit

final class NotesListViewController: UIViewController {

    lazy var oneNoteViewController = OneNoteViewController()
    lazy var notesStorage: NotesStorageProtocol = NotesKeychainStorage.shared
    private lazy var notes = [Note]()
    private var isNoteEditing: Bool { oneNoteViewController.title == "Редактирование заметки" }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.backgroundColor = .systemGray6
        table.delegate = self
        table.dataSource = self
        table.register(NotesListCell.self, forCellReuseIdentifier: NotesListCell.identifier)
        return table
    }()

    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "StarIcon")
        return imageView
    }()

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем записывать?"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        setupConstraints()
        setupNavigationController()
        loadMockNote()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stubImageView.isHidden = notes.isEmpty ? false : true
        stubLabel.isHidden = notes.isEmpty ? false : true
    }

    private func loadMockNote() {
        notes.append(Note.makeMockNote())
    }

    private func setupNavigationController() {
        view.backgroundColor = .white
        title = "Мои заметки"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                          target: self,
                                          action: #selector(addNote))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.backButtonTitle = "Назад"
    }

    private func loadNotes() {
        guard let notes = notesStorage.loadNotes() else { return }
        self.notes = notes
    }

    @objc private func addNote() {
        oneNoteViewController.title = "Новая заметка"
        oneNoteViewController.callback = { [weak self] newNote in
            guard let self = self else { return }
            self.notes.insert(newNote, at: 0)
            self.notesStorage.save(notes: self.notes)
            self.updateTableView(at: IndexPath(row: 0, section: 0))
        }
        navigationController?.pushViewController(oneNoteViewController, animated: true)
    }

    private func editNote(by index: Int) {
        oneNoteViewController.title = "Редактирование заметки"
        oneNoteViewController.editableNote = notes[index]
        oneNoteViewController.callback = { [weak self] editedNote in
            guard let self = self else { return }
            self.notes[index] = editedNote
            self.notesStorage.save(notes: self.notes)
            self.updateTableView(at: IndexPath(row: index, section: 0))
        }
        navigationController?.pushViewController(oneNoteViewController, animated: true)
    }

    private func updateTableView(at indexPath: IndexPath) {
        tableView.performBatchUpdates {
            if !isNoteEditing {
                tableView.insertRows(at: [indexPath], with: .automatic)
                return
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    private func setupConstraints() {
        [tableView, stubImageView, stubLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension NotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editNote(by: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            notesStorage.save(notes: notes)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesListCell.identifier) as? NotesListCell else { return UITableViewCell() }
        cell.setNote(title: notes[indexPath.row].title)
        cell.setNote(text: notes[indexPath.row].text)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
