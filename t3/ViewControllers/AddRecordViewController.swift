import UIKit

final class AddRecordViewController: UIViewController {
    private let repository: MedicalRecordRepository
    private let contentView = AddRecordView()

    init(repository: MedicalRecordRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro"
        contentView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() {
        guard let fullName = contentView.fullNameField.text, !fullName.isEmpty,
              let age = Int16(contentView.ageField.text ?? ""),
              let weight = Double(contentView.weightField.text ?? ""),
              let height = Double(contentView.heightField.text ?? ""),
              let pressure = contentView.pressureField.text, !pressure.isEmpty
        else {
            showAlert(title: "Campos inválidos", message: "Completa todos los campos requeridos.")
            return
        }

        repository.create(
            fullName: fullName,
            age: age,
            weight: weight,
            height: height,
            bloodPressure: pressure,
            comment: contentView.commentField.text ?? ""
        )

        showAlert(
            title: "Registro correcto",
            message: "Su registro de control médico se realizó correctamente.",
            popOnDismiss: true
        )
    }

    private func showAlert(title: String, message: String, popOnDismiss: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entiendo", style: .default) { [weak self] _ in
            if popOnDismiss { self?.navigationController?.popViewController(animated: true) }
        })
        present(alert, animated: true)
    }
}
