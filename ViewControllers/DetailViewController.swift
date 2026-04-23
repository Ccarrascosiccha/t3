import UIKit

final class DetailViewController: UIViewController {
    private let record: MedicalRecord
    private let repository: MedicalRecordRepository
    private let contentView = DetailView()

    init(record: MedicalRecord, repository: MedicalRecordRepository) {
        self.record = record
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
        title = "Detalle"
        contentView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        renderDetail()
    }

    private func renderDetail() {
        let bmi = BMIHelper.value(weight: record.weight, height: record.height)
        let bmiLabel = BMIHelper.classification(for: bmi)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateText = formatter.string(from: record.createdAt ?? Date())

        contentView.textView.text = """
        Fecha: \(dateText)

        Paciente: \(record.fullName ?? "")
        Edad: \(record.age)
        Altura: \(String(format: "%.2f", record.height)) m
        Peso: \(String(format: "%.2f", record.weight)) kg
        Presión Arterial: \(record.bloodPressure ?? "")

        Comentarios:
        \(record.comment ?? "")

        Índice de Masa Corporal (IMC): \(String(format: "%.2f", bmi))
        Clasificación: \(bmiLabel)
        """
    }

    @objc private func deleteTapped() {
        let alert = UIAlertController(
            title: "Eliminar Registro",
            message: "Los datos se eliminarán permanentemente",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.repository.delete(self.record)
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
