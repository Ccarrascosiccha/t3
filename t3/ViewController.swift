import UIKit

final class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if navigationController != nil {
            navigationController?.setViewControllers([MedicalListViewController()], animated: false)
            return
        }

        let root = UINavigationController(rootViewController: MedicalListViewController())
        root.modalPresentationStyle = .fullScreen
        present(root, animated: false)
    }
}
