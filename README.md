# <img width="80px" src="https://user-images.githubusercontent.com/10897361/43182946-57c57d9a-901e-11e8-99ad-3d19664f5f6a.png"/> Conv
Conv smart represent UICollectionView data structure more than UIKit.  
And easy definition for UICollectionView DataSource and Delegate methods.  

Conv means Seaweed in Japan.  
This library inspired [Shoyu](https://github.com/yukiasai/shoyu). Thanks @yukiasai.

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

            // Create sections for count of elements. 
            .create(for: SectionType.elements) { (sectionType, section) in
                // In closure passed each element from elements and configuration for section.

                // Section has creating section header or footer method.
                // `create header or footer` method to use generics and convert automaticary each datasource and delegate method.(e.g SectionHeaderFooter<ListCollectionReusableView>)
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<ListCollectionReusableView>) in

                    // Setting each property and wrapped datasource or delegate method
                    header.reusableIdentifier = "ListCollectionReusableView"
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView { view, _ in
                        // `view` was converted to ListCollectionReusableView

                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = sectionType.backgroundColor
                    }
                })

                // Section has creating items for count of elements. 
                // `create item` method to use generics type and convert automaticary to each datasource and delegate method. (e.g Item<ListCollectionViewCell>
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: Item<ListCollectionViewCell>) in
                    // In closure passed each element from elements and configuration for section.

                    // Setting each property and wrapped datasource or delegate method
                    item.reusableIdentifier = "ListCollectionViewCell"
                    item.sizeFor({ _ -> CGSize in
                        let gridCount: CGFloat = 3
                        let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                        let size = CGSize(width: edge, height: edge)
                        return size
                    })

                    item.configureCell { (cell, info) in

                        // cell was converted to ListCollectionViewCell
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

