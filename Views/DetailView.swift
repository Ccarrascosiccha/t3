import UIKit

final class DetailView: UIView {
    let textView = UITextView()
    let deleteButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 18)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Eliminar Registro", for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 12

        addSubview(textView)
        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            deleteButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
