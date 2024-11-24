//
//

import UIKit

// MARK: - BusinessCell

final class BusinessCell: UITableViewCell {

    private enum ViewConstants {
        static let imageSize = 90.0
        static let starSize = 16.0
        static let verticalPadding = 8.0
        static let horizontalPadding = 12.0
    }

    // MARK: Views

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let ratingView: UIStackView = {
        var stars: [UIImageView] = []
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .gray
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: ViewConstants.starSize).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: ViewConstants.starSize).isActive = true
            stars.append(starImageView)
        }
        let stackView = UIStackView(arrangedSubviews: stars)
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo") // Placeholder
        return imageView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusLabel, nameLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var imageLoadTask: Task<Void, Never>?
    private var indexPath: IndexPath?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(businessImageView)
        contentView.addSubview(textStackView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel() // Cancel the current image load task if any
        imageLoadTask = nil
        businessImageView.image = UIImage(systemName: "photo") // Reset placeholder image
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            businessImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.verticalPadding),
            businessImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.horizontalPadding),
            businessImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            businessImageView.heightAnchor.constraint(equalToConstant: ViewConstants.imageSize),
            businessImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -ViewConstants.verticalPadding),

            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: businessImageView.trailingAnchor, constant: ViewConstants.horizontalPadding),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.horizontalPadding),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -ViewConstants.verticalPadding)
        ])
    }

    func configure(with business: Business, indexPath: IndexPath, repository: BusinessRepository) {
        statusLabel.text = business.isClosed ? String(localized: "Closed") : String(localized: "Open Now")
        statusLabel.textColor = business.isClosed ? .red : .gray
        nameLabel.text = business.name

        let starCount = Int(business.rating)
        for (index, starImageView) in ratingView.arrangedSubviews.enumerated() {
            if let starImageView = starImageView as? UIImageView {
                starImageView.image = UIImage(systemName: index < starCount ? "star.fill" : "star")
                starImageView.tintColor = index < starCount ? .systemYellow : .gray
            }
        }

        imageLoadTask = Task {
            let image = try? await repository.getImage(for: business.imageURL)
            await MainActor.run { [weak self] in
                self?.businessImageView.image = image ?? UIImage(systemName: "photo")
            }
        }
    }
}
