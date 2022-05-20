//
//  ChartImageController.swift
//  
//
//  Created by Will Dale on 04/05/2022.
//

import Foundation

#if os(iOS)
import Combine
import SwiftUI
import UIKit

public final class ChartImageController {
    public var controller: UIViewController?
    
    public init() {}
}

public final class ChartImageHostingController<Content: View>: UIHostingController<Content> {
    
    public var finalImage = PassthroughSubject<UIImage, Never>()
    private var cancellable: AnyCancellable?
    
    public override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        cancellable = NotificationCenter.default
            .publisher(for: .updateLayoutDidFinish)
            .sink { [weak self] _ in self?.drawView() }
    }
    
    public func start() {
        let targetSize = view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        _ = renderer.image { context in
            view?.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    private func drawView() {
        let targetSize = view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { context in
            view?.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        finalImage.send(image)
        cancellable?.cancel()
        finalImage.send(completion: .finished)
    }
}
#endif
