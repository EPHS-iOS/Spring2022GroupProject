//
//  LoadingSquareView.swift
//  ScavengeItAnimations
//
//  Created by Lucas Wagner on 4/18/22.
//

import SwiftUI
import Lottie

struct OnboardingScreen : UIViewRepresentable {
    typealias UIViewType = UIView
    func makeUIView(context: UIViewRepresentableContext<OnboardingScreen>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named("PostItAnimation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor), animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
                                    ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<OnboardingScreen>) {
    }
}

