import UIKit

final class MedicalListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let repository = MedicalRecordRepository()
    private var records: [MedicalRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Control Médico"
        view.backgroundColor = .systemBackground
        setupTable()
        setupNavigation()
        fetchRecords()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecords()
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Agregar",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MedicalRecordCell.self, forCellReuseIdentifier: MedicalRecordCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchRecords() {
        do {
            records = try repository.fetchAll()
            tableView.reloadData()
        } catch {
            print("Error fetching: \(error)")
        }
    }

    @objc private func addTapped() {
        navigationController?.pushViewController(AddRecordViewController(repository: repository), animated: true)
    }
}

extension MedicalListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MedicalRecordCell.reuseIdentifier,
            for: indexPath
        ) as? MedicalRecordCell else {
            return UITableViewCell()
        }

        let record = records[indexPath.row]
        cell.configure(with: record)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(record: records[indexPath.row], repository: repository)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
