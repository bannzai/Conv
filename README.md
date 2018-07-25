# Conv
Conv smart represent UICollectionView data structure more than UIKit.
And easy definition for UICollectionView DataSource and Delegate methods.

Conv means Seaweed in Japan.
This library inspired [Shoyu](https://github.com/yukiasai/shoyu). Thanks.

<img width="320px" src="https://user-images.githubusercontent.com/10897361/43182946-57c57d9a-901e-11e8-99ad-3d19664f5f6a.png"/>

# Usage
First, create instance for UICollectionView(or subclass).

```swift
let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
```

Second, register to use cell and reusable view for `collectionView`.

```
collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
collectionView.register(UINib(nibName: "ListCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ListCollectionReusableView")
```

Next, call `conv()` method from `collectionView` and start definition UICollectionView DataSource and Delegate.

```swift
        collectionView
            .conv()
            .create(for: SectionType.elements) { (sectionType, section) in
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<ListCollectionReusableView>) in
                    header.reusableIdentifier = "ListCollectionReusableView"
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView { view, _ in
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = sectionType.backgroundColor
                    }
                })
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: Item<ListCollectionViewCell>) in
                    item.reusableIdentifier = "ListCollectionViewCell"
                    item.sizeFor({ _ -> CGSize in
                        let gridCount: CGFloat = 3
                        let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                        let size = CGSize(width: edge, height: edge)
                        return size
                    })

                    item.configureCell { (cell, info) in
                        cell.setup(with: viewModel)
                    }
                    
                    item.didSelect { [weak self] (item) in
                        let viewController = DetailViewController(imageName: viewModel.imageName)
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                })
        }
```

Last, If you want to render of `collectionView`, you call `collectionView.reloadData()` for best timing.

```swift
collectionView.reloadData()
```

You can check more example to [ConvExmaple](https://github.com/bannzai/Conv/tree/master/ConvExample/)

