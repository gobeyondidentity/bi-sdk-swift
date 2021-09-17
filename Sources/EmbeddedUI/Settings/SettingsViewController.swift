import Anchorage
import Embedded
import SharedDesign

#if os(iOS)
import UIKit

class SettingsViewController: ViewController {
    private let config: BeyondIdentityConfig
    
    private(set) var credential: Credential? = nil
    private(set) var tableData = [TableData]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingOptionCell.self, forCellReuseIdentifier: SettingOptionCell.reuseIdentifier)
        tableView.tableFooterView = View()
        return tableView
    }()
    
    init(
        config: BeyondIdentityConfig
    ) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        
        title = LocalizedString.settingScreenTitle.string
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background.value
        
        let poweredByBILogo = ImageView(image: .poweredByBILogo)
        poweredByBILogo.contentMode = .scaleAspectFit
        poweredByBILogo.setImageColor(color: Colors.body.value)
        
        let stack = StackView(arrangedSubviews: [tableView, poweredByBILogo])
        stack.axis = .vertical
        
        view.addSubview(stack)
        
        stack.topAnchor == view.safeAreaLayoutGuide.topAnchor
        stack.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - Spacing.section
        stack.horizontalAnchors == view.safeAreaLayoutGuide.horizontalAnchors
    }
    
    func setTableData() {
        Embedded.shared.getCredentials { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(credentials):
                if let credential = credentials.first {
                    self.credential = credential
                }
                self.tableData = self.getTableData(for: credentials.count)
            case let .failure(error):
                let alert = ErrorAlert(
                    title: LocalizedString.settingCredentialNotFoundError.string,
                    message: error.localizedDescription,
                    responseTitle: LocalizedString.alertErrorAction.string
                )
                alert.show(with: self)
            }
        }
    }
    
    func getTableData(for count: Int) -> [TableData] {
        if count == 0 {
            return [
                TableData(
                    title: LocalizedString.settingOptionAddCredential.string,
                    detail: nil,
                    option: .addCredential
                )
            ]
        }else {
            return [
                TableData(
                    title: LocalizedString.settingOptionViewCredential.string,
                    detail: nil,
                    option: .viewCredential
                ),
                TableData(
                    title: LocalizedString.settingOptionShowQRCode.string,
                    detail: LocalizedString.settingOptionShowQRCodeDetail.string,
                    option: .showQRCode
                )
            ]
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
} 

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingOptionCell.reuseIdentifier,
                for: indexPath) as? SettingOptionCell else { return UITableViewCell() }
        cell.configure(tableData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedOption(tableData[indexPath.row].option)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tappedOption(_ option: SettingOption){
        switch option {
        case .addCredential:
            let addCredentialVC = AddCredentialViewController(
                config: config
            )
            navigationController?.pushViewController(addCredentialVC, animated: true)
        case .viewCredential:
            guard let credential = credential else { return }
            
            let credentialInfoVC = CredentialInfoViewController(
                credential: credential,
                appName: config.appName
            )
            navigationController?.pushViewController(credentialInfoVC, animated: true)
        case .showQRCode:
            guard let credential = credential else { return }
            let showQRCodeVC = ShowQRCodeViewController(
                credential: credential,
                appName: config.appName
            )
            navigationController?.pushViewController(showQRCodeVC, animated: true)
        }
    }
}
#endif
