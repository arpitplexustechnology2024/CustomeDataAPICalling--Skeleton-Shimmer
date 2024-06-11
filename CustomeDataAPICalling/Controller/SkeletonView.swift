//
//  SkeletonView.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 07/06/24.
//

import Foundation
import UIKit

//class SkeletonView: UIView {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupSkeleton()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupSkeleton()
//    }
//    
//    private func setupSkeleton() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor, UIColor.lightGray.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.locations = [0.0, 0.5, 1.0]
//        gradientLayer.frame = self.bounds
//        gradientLayer.add(createShimmerAnimation(), forKey: "shimmer")
//        self.layer.addSublayer(gradientLayer)
//    }
//    
//    private func createShimmerAnimation() -> CABasicAnimation {
//        let animation = CABasicAnimation(keyPath: "locations")
//        animation.fromValue = [0.0, 0.0, 0.25]
//        animation.toValue = [0.75, 1.0, 1.0]
//        animation.duration = 1.5
//        animation.repeatCount = .infinity
//        return animation
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.sublayers?.forEach { $0.frame = self.bounds }
//    }
//}

class AvatarSkeletonTableViewCell: UITableViewCell {
    
    private let skeletonImageView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkeleton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }
    
    private func setupSkeleton() {
        // Setup the skeleton view
        skeletonImageView.backgroundColor = .lightGray
        skeletonImageView.clipsToBounds = true
        contentView.addSubview(skeletonImageView)
        
        skeletonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skeletonImageView.widthAnchor.constraint(equalToConstant: 155),
            skeletonImageView.heightAnchor.constraint(equalToConstant: 155),
            skeletonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            skeletonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        // Setup the gradient layer for shimmer effect
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = skeletonImageView.bounds
        gradientLayer.add(createShimmerAnimation(), forKey: "shimmer")
        skeletonImageView.layer.addSublayer(gradientLayer)
    }
    
    private func createShimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        return animation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = skeletonImageView.bounds
    }
}
