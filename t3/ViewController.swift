//
//  ViewController.swift
//  t3
//

import UIKit
import CoreData

@objc(Entity)
class MedicalRecord: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var fullName: String?
    @NSManaged var age: Int16
    @NSManaged var weight: Double
    @NSManaged var height: Double
    @NSManaged var bloodPressure: String?
    @NSManaged var comment: String?
    @NSManaged var createdAt: Date?
}

class MedicalListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var records: [MedicalRecord] = []

    private var viewContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control Médico"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Agregar",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        setupTable()
        fetchRecords()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecords()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 96

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchRecords() {
        let request = NSFetchRequest<MedicalRecord>(entityName: "Entity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            records = try viewContext.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching: \(error)")
        }
    }

    @objc private func addTapped() {
        navigationController?.pushViewController(AddRecordViewController(), animated: true)
    }
}

extension MedicalListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let record = records[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = record.fullName ?? "Sin nombre"

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateText = formatter.string(from: record.createdAt ?? Date())
        content.secondaryText = "PA: \(record.bloodPressure ?? "-") · \(dateText)"
        content.secondaryTextProperties.numberOfLines = 2

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(record: records[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }
}

class AddRecordViewController: UIViewController {
    private let stack = UIStackView()
    private let fullNameField = UITextField()
    private let ageField = UITextField()
    private let weightField = UITextField()
    private let heightField = UITextField()
    private let pressureField = UITextField()
    private let commentField = UITextField()

    private var viewContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro"
        view.backgroundColor = .systemBackground
        setupForm()
    }

    private func setupForm() {
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

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Registrar", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        stack.addArrangedSubview(saveButton)

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func configure(_ textField: UITextField, _ placeholder: String, _ keyboard: UIKeyboardType) -> UITextField {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboard
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }

    @objc private func saveTapped() {
        guard let fullName = fullNameField.text, !fullName.isEmpty,
              let age = Int16(ageField.text ?? ""),
              let weight = Double(weightField.text ?? ""),
              let height = Double(heightField.text ?? ""),
              let pressure = pressureField.text, !pressure.isEmpty
        else {
            showAlert(title: "Campos inválidos", message: "Completa todos los campos requeridos.")
            return
        }

        let record = MedicalRecord(entity: NSEntityDescription.entity(forEntityName: "Entity", in: viewContext)!, insertInto: viewContext)
        record.id = UUID()
        record.fullName = fullName
        record.age = age
        record.weight = weight
        record.height = height
        record.bloodPressure = pressure
        record.comment = commentField.text ?? ""
        record.createdAt = Date()

        do {
            try viewContext.save()
            showAlert(title: "Registro correcto", message: "Su registro de control médico se realizó correctamente.", popOnDismiss: true)
        } catch {
            showAlert(title: "Error", message: "No se pudo guardar el registro.")
        }
    }

    private func showAlert(title: String, message: String, popOnDismiss: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entiendo", style: .default) { [weak self] _ in
            if popOnDismiss { self?.navigationController?.popViewController(animated: true) }
        })
        present(alert, animated: true)
    }
}

class DetailViewController: UIViewController {
    private let record: MedicalRecord
    private let textView = UITextView()

    private var viewContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    init(record: MedicalRecord) {
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"
        view.backgroundColor = .systemBackground

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)

        let deleteButton = UIButton(type: .system)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Eliminar Registro", for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            deleteButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        renderDetail()
    }

    private func renderDetail() {
        let bmi = record.weight / max((record.height * record.height), 0.01)
        let bmiLabel: String
        switch bmi {
        case ..<18.5: bmiLabel = "Bajo peso"
        case 18.5..<25: bmiLabel = "Peso normal"
        case 25..<30: bmiLabel = "Sobrepeso"
        default: bmiLabel = "Obesidad"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateText = formatter.string(from: record.createdAt ?? Date())

        textView.text = """
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
            self.viewContext.delete(self.record)
            do {
                try self.viewContext.save()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error deleting: \(error)")
            }
        })
        present(alert, animated: true)
    }
}
