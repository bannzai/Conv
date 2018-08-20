[![Conv](Logo/conv_logo.png)](https://github.com/bannzai/Conv)


<p align="center">
  <a href="https://developer.apple.com/swift"><img alt="Swift4" src="https://img.shields.io/badge/language-swift4-blue.svg?style=flat"/></a>
  <a href="https://cocoapods.org/pods/Conv"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/Conv.svg"/></a>
  <a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat"/></a>
  </br>
  <a href="https://developer.apple.com/swift/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a>
  <a href="https://github.com/bannzai/Conv/blob/master/LICENSE.txt"><img alt="Lincense" src="http://img.shields.io/badge/license-MIT-000000.svg?style=flat"/></a>
</p>


# Conv

Conv smart represent UICollectionView data structure more than UIKit.  
And easy definition for UICollectionView DataSource and Delegate methods.  

Conv(called KONBU) means Seaweed in Japan.  
This library is inspired by [Shoyu](https://github.com/yukiasai/shoyu). Thanks @yukiasai.

# Usage
First, create instance for UICollectionView(or subclass).  

```swift
let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
```

Second, register to use cell and reusable view for `collectionView`.  

```swift
collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
collectionView.register(UINib(nibName: "ListCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ListCollectionReusableView")
```

Next, call `define()` method from `collectionView` and create `Conv` and start definition UICollectionView DataSource and Delegate.  

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
                // `create item` method to use generics type and convert automaticary to each datasource and delegate method. (e.g Item<ListCollectionViewCell>)
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

Last, If you want to render of `collectionView`, you call `collectionView.reload()` for best timing.  
`reload()` calculate diff for between before section and between before items and for minimum reloading data.  
So, fast reloading more than `collectionView.reloadData()`.

```swift
collectionView.reload()
```

You can check more example to [ConvExmaple](https://github.com/bannzai/Conv/tree/master/ConvExample/)  

# Install
## CocoaPods
Conv is available through Cocoapods.  
You can write it into target and exec `pod install`.

```
pod 'Conv'
```

## Carthage
Conv is available through Carhtage.  
You can write it into target and exec `carthage update --platform iOS`.
And find conv framework and embed your project.

```
github 'bannzai/Conv'
```

# Why Conv?
UIKit.UICollectionView has some problems.

1. UICollectionView.dequeueXXX method not type safe. So, should convert to want class each cells. 
2. UICollectionViewDataSource and UICollectionViewDelegate(or DelegateFlowLayout) far away each configured functions. So, reading configuration flow for each indexPath very difficalt.
3. Many case to use UICollectionView with Array. But extract element from array using indexPath many time.

Conv resolve these problem.
1. Conv does not need to call UICollectionView.dequeueXXX. Because you can define configureCell method and get converted custom class cell. 

```swift
item.configureCell { (cell, info) in

    // cell was converted to ListCollectionViewCell
    cell.setup(with: viewModel)
}
```

2. You can write to neary for each UICollectionView component. section,item,header and footer.
So, this definition to be natural expression for UICollectionView data strcture, hierarchy, releation.

3. When create section or item, you can passed elements for configure UICollectionView.
Next, each element pass closure argument that define Conv.Section or Conv.Item.
So, You can represent CollectionView data structure with extracted each element.

## Other
### Algorithm
Conv to use diffing algorithm based on the Paul Heckel's algorithm.    
And I also referred to other libraries below.  

- https://github.com/mcudich/HeckelDiff
- https://github.com/ra1028/DifferenceKit
- https://github.com/Instagram/IGListKit/

# LICENSE
[Conv](https://github.com/bannzai/Conv/) is released under the MIT license. See [LICENSE](https://github.com/bannzai/Conv/blob/master/LICENSE.txt) for details.

Header logo is released [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/deed) license. Original design by [noainoue](https://github.com/noainoue).


