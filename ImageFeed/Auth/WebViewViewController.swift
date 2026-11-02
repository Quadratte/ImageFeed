import WebKit

// MARK: - WebViewViewControllerProtocol
public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

// MARK: - WebViewViewControllerDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - WebViewViewController
final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var isLoadRequestCalled = false

    // MARK: - UI Components
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .ypBlack
        return view
    }()

    // MARK: - Properties
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - Lifecyclef
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebView()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    // MARK: - Setup
    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .ypBlack
        view.backgroundColor = .ypWhite
        view.addSubview(webView)
        view.addSubview(progressView)
        configureBackButton()
    }

    private func setupWebView() {
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    // MARK: - Configure
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = .navBackButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = .navBackButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }

    func load(request: URLRequest) {
        isLoadRequestCalled = true
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    private func addObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
