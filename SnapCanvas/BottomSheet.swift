import UIKit
import SwiftUI

class BottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: BottomSheetViewModel
    
    init(viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomSheet()
    }
    
    private func setupBottomSheet() {
        
        // Container for the button sheet
        let buttonSheetView = UIView()
        buttonSheetView.backgroundColor = .black
        buttonSheetView.layer.cornerRadius = 10
        buttonSheetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSheetView)
        
        // Constraints for the button sheet view
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            buttonSheetView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            buttonSheetView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            buttonSheetView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            buttonSheetView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Stack view for buttons
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonSheetView.addSubview(stackView)
        
        // Constraints for stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: buttonSheetView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: buttonSheetView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: buttonSheetView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: buttonSheetView.heightAnchor)
        ])
        
        for (imageName, title) in viewModel.buttonsInfo {
            let button = createButtonWithImageAndText(imageName: imageName, title: title)
            stackView.addArrangedSubview(button)
        }
    }
    
    func createButtonWithImageAndText(imageName: String, title: String) -> UIView {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        let stackView = UIStackView(arrangedSubviews: [button, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    @objc private func buttonAction() {
        // Handle button action
        viewModel.OverlayButtonTapped()
    }
}

struct BottomSheetRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BottomSheetViewController {
        // Create the bottom sheet view controller
        return BottomSheetViewController(viewModel: BottomSheetViewModel())
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: BottomSheetViewController, context: Context) -> CGSize? {
        let height: Double = 300
        let width = Double(UIScreen.main.bounds.width)
        return CGSize(width: width, height: height)
    }
    
    func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        // Update the view controller when SwiftUI state changes, if necessary
    }
    
    typealias UIViewControllerType = BottomSheetViewController
}
