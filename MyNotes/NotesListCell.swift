//
//  NotesListCell.swift
//  MyNotes
//
//  Created by Юрий Демиденко on 13.01.2023.
//

import UIKit

final class NotesListCell: UITableViewCell {

    private lazy var noteTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    private lazy var noteTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .lightGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .systemGray6
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    private func setupConstraints() {
        [noteTitleLabel, noteTextLabel].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            noteTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            noteTextLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 2),
            noteTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            noteTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    func setNote(title: String) {
        noteTitleLabel.text = title
    }

    func setNote(text: String) {
        noteTextLabel.text = text
    }
}
