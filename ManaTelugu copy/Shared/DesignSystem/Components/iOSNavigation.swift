import UIKit
import SwiftUI

// MARK: - iOS Native Navigation Components
// Implements proper iOS navigation hierarchy and patterns

// MARK: - iOS Navigation Bar Configuration
class iOSNavigationBarManager {
    static let shared = iOSNavigationBarManager()
    
    private init() {}
    
    func configureNavigationBar(for viewController: UIViewController, title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Glass effect for navigation bar
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.glassWhite
        
        // Title styling
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.teluguHeadlineDynamic()
        ]
        
        // Large title styling
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.teluguTitleDynamic()
        ]
        
        // Apply appearance
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        viewController.navigationController?.navigationBar.compactAppearance = appearance
        
        // Configure navigation bar
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
        viewController.navigationController?.navigationBar.isTranslucent = true
        viewController.navigationController?.navigationBar.tintColor = UIColor.teluguBlue
        
        viewController.title = title
    }
    
    func addGlassBackButton(to viewController: UIViewController) {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: viewController.navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        
        backButton.tintColor = UIColor.teluguBlue
        viewController.navigationItem.leftBarButtonItem = backButton
    }
    
    func addGlassActionButton(to viewController: UIViewController, title: String, action: @escaping () -> Void) {
        let actionButton = UIBarButtonItem(
            title: title,
            style: .plain,
            target: nil,
            action: nil
        )
        
        actionButton.tintColor = UIColor.teluguBlue
        actionButton.setTitleTextAttributes([
            .font: UIFont.teluguBodyDynamic()
        ], for: .normal)
        
        viewController.navigationItem.rightBarButtonItem = actionButton
    }
}

// MARK: - iOS Tab Bar Configuration
class iOSTabBarManager {
    static let shared = iOSTabBarManager()
    
    private init() {}
    
    func configureTabBar(for tabBarController: UITabBarController) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Glass effect for tab bar
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = UIColor.glassWhite
        
        // Tab bar styling
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.teluguCaptionDynamic()
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.teluguBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.teluguBlue,
            .font: UIFont.teluguCaptionDynamic()
        ]
        
        // Apply appearance
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        // Configure tab bar
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = UIColor.teluguBlue
        tabBarController.tabBar.unselectedItemTintColor = UIColor.secondaryLabel
    }
}

// MARK: - iOS Collection View Layout
class iOSCollectionViewLayoutManager {
    static func createTeluguLearningLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0: // Welcome section
                return createWelcomeSection()
            case 1: // Stats section
                return createStatsSection()
            case 2: // Lessons section
                return createLessonsSection()
            case 3: // Stories section
                return createStoriesSection()
            default:
                return createDefaultSection()
            }
        }
        
        return layout
    }
    
    private static func createWelcomeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        
        return section
    }
    
    private static func createStatsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/3.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        
        return section
    }
    
    private static func createLessonsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 12
        
        return section
    }
    
    private static func createStoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 12
        
        return section
    }
    
    private static func createDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        
        return section
    }
}

// MARK: - iOS Table View Configuration
class iOSTableViewManager {
    static func configureTableView(_ tableView: UITableView) {
        // iOS settings style
        tableView.backgroundColor = UIColor.systemGroupedBackground
        tableView.separatorStyle = .none
        
        // Register cells
        tableView.register(iOSGlassTableViewCell.self, forCellReuseIdentifier: "GlassCell")
        tableView.register(iOSGlassHeaderView.self, forHeaderFooterViewReuseIdentifier: "GlassHeader")
    }
}

// MARK: - iOS Glass Table View Cell
class iOSGlassTableViewCell: UITableViewCell {
    private var glassView: iOSGlassEffectView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupGlassCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlassCell()
    }
    
    private func setupGlassCell() {
        // Remove default background
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        // Add glass background
        glassView = iOSGlassEffectView()
        glassView.glassType = .regular
        glassView.cornerRadius = 12
        glassView.isUserInteractionEnabled = false
        contentView.insertSubview(glassView, at: 0)
        
        // Configure text labels
        textLabel?.font = UIFont.teluguBodyDynamic()
        textLabel?.textColor = UIColor.label
        detailTextLabel?.font = UIFont.teluguCaptionDynamic()
        detailTextLabel?.textColor = UIColor.secondaryLabel
        
        // Add disclosure indicator
        accessoryType = .disclosureIndicator
        tintColor = UIColor.teluguBlue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Position glass view
        let margin: CGFloat = 8
        glassView.frame = CGRect(
            x: margin,
            y: margin,
            width: bounds.width - (margin * 2),
            height: bounds.height - (margin * 2)
        )
        
        // Adjust text label position
        textLabel?.frame.origin.x = 20
        detailTextLabel?.frame.origin.x = 20
    }
}

// MARK: - iOS Glass Header View
class iOSGlassHeaderView: UITableViewHeaderFooterView {
    private var glassView: iOSGlassEffectView!
    private var titleLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupGlassHeader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlassHeader()
    }
    
    private func setupGlassHeader() {
        // Remove default background
        backgroundView = UIView()
        
        // Add glass background
        glassView = iOSGlassEffectView()
        glassView.glassType = .subtle
        glassView.cornerRadius = 8
        glassView.isUserInteractionEnabled = false
        addSubview(glassView)
        
        // Add title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.teluguHeadlineDynamic()
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Position glass view
        let margin: CGFloat = 16
        glassView.frame = CGRect(
            x: margin,
            y: 8,
            width: bounds.width - (margin * 2),
            height: bounds.height - 16
        )
        
        // Position title label
        titleLabel.frame = CGRect(
            x: 24,
            y: 8,
            width: bounds.width - 48,
            height: bounds.height - 16
        )
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - SwiftUI Integration
struct iOSNavigationView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct iOSTabView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        TabView {
            content
        }
        .toolbarBackground(.regularMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
