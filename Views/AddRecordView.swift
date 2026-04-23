import UIKit

final class AddRecordView: UIView {
    let fullNameField = UITextField()
    let ageField = UITextField()
    let weightField = UITextField()
    let heightField = UITextField()
    let pressureField = UITextField()
    let commentField = UITextField()
    let saveButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        [
            configure(fullNameField, "Nombres y apellidos", .default),
            configure(ageField, "Edad", .numberPad),
            configure(weightField, "Peso (kg)", .decimalPad),
            configure(heightField, "Altura (m)", .decimalPad),
            configure(pressureField, "Presión arterial", .default),
            configure(commentField, "Comentario", .default)
        ].forEach { stack.addArrangedSubview($0) }

        saveButton.setTitle("Registrar", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        stack.addArrangedSubview(saveButton)

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func configure(_ field: UITextField, _ placeholder: String, _ keyboard: UIKeyboardType) -> UITextField {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.keyboardType = keyboard
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return field
    }
}
