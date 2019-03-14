<div align="center" >
  <img width="70%" src="Logo/conv_logo.png" />
</div>

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
Easy definition for UICollectionView DataSource and Delegate methods.  

<img width="100%" src="https://user-images.githubusercontent.com/10897361/45803758-54c4e780-bcf5-11e8-8724-7ea779589331.png" />


And Conv reload fast to use diffing algorithm based on the Paul Heckel's algorithm.   

|  Insert and Delete  |  Move item and section  |
| ---- | ---- |
|  <img width="320px" src="https://user-images.githubusercontent.com/10897361/44513426-484e6e80-a6f8-11e8-83cc-78e533521588.gif" />  |  <img width="320px" src="https://user-images.githubusercontent.com/10897361/44513427-48e70500-a6f8-11e8-9e1e-7957f60a2918.gif" />  |

Conv(called KONBU) means Seaweed in Japan.  
This library is inspired by [Shoyu](https://github.com/yukiasai/shoyu). Thanks [@yukiasai](https://github.com/yukiasai).

# Usage
**First**, Conv need to prepare array of definition datastructure for section and item.
And then it should conform `Differenciable` protocol for difference algorithm.

### Section
```swift
enum SectionType: Int {
  case one
  case two
  case three

  static var allCases: [SectionType] {
    return [.one, .two, .three]
  }
}

extension SectionType: Differenciable {
  var differenceIdentifier: DifferenceIdentifier {
    return "\(self)"
  }
}
```

```swift
let sectionTypes = SectionType.allCases
```

### Item
```swift
struct ItemModel {
    let index: Int
    let imageName: String
    var image: UIImage {
        return UIImage(named: imageName)!
    }
}

extension ItemModel: Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(index)" + imageName
    }
}
```

```swift
let itemModels = [
    ItemModel(index: 1, imageName: "forest"),
    ItemModel(index: 2, imageName: "moon"),
    ItemModel(index: 3, imageName: "pond"),
    ItemModel(index: 4, imageName: "river"),
]
```

**Second**, start to define data structure for section and item.   
It use prepared Differenciable array.  

```swift
collectionView
    .conv // #1
    .diffing() 
    .start() 
    .append(for: sectionTypes) { (sectionType, section) in // #2
        section.append(.header, headerOrFooter: { (header: SectionHeaderFooter<ListCollectionReusableView>) in // #3
            header.reusableIdentifier = "ListCollectionReusableView"
            header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
            header.configureView { view, _ in
                view.nameLabel.text = "\(sectionType)".uppercased()
                view.nameLabel.textColor = .white
                view.backgroundColor = sectionType.backgroundColor
            }
        })
        section.append(for: itemModels, items: { (itemModel, item: Item<ListCollectionViewCell>) in // #4
            item.reusableIdentifier = "ListCollectionViewCell"
            item.sizeFor({ _ -> CGSize in
                let gridCount: CGFloat = 3
                let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                let size = CGSize(width: edge, height: edge)
                return size
            })
            
            item.configureCell { (cell, info) in
                cell.setup(with: itemModel)
            }
            
            item.didSelect { [weak self] (item) in
                let viewController = DetailViewController(imageName: itemModel.imageName)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        })
}
```

This swift code has the following meaning. It explain for `#` mark in code.
1. Start to define UICollectionView data structure it using `Conv`.
2. Append sections that number of sectionTypes. And start define about section. 
3. Append section header for each section. And start define about section header.
4. Append items that number of itemModels for each section. And start define about item.

**Last**, If you want to render of `collectionView`, you call `collectionView.update()` your best timing.  
`update()` calculate diff for minimum reloading data between before section and between before items.

```swift
collectionView.conv.update()
```

Or if you want to all realod cells, you can call `reload()`. 
It will be same behavior of `collectionView.reloadData()`.

```swift
collectionView.conv.reload()
```

You can see more example to [ConvExmaple](https://github.com/bannzai/Conv/tree/master/ConvExample/)  

# Algorithm
Conv to use diffing algorithm based on the Paul Heckel's algorithm.    
And I also referred to other libraries below.  

- https://github.com/mcudich/HeckelDiff
- https://github.com/ra1028/DifferenceKit
- https://github.com/Instagram/IGListKit/

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
section.append(for: itemModels, items: { (itemModel, item: Item<ListCollectionViewCell>) in // #4
    ...
    item.configureCell { (cell, info) in
        // cell is converted ListCollectionViewCell
        cell.setup(with: itemModel)
    }
})
```

2. You can write to neary for each UICollectionView component. section,item,header and footer.
So, this definition to be natural expression for UICollectionView data strcture, hierarchy, releation.

3. When append section or item, you can passed allCases for configure UICollectionView.
Next each element pass closure argument that define Conv.Section or Conv.Item.
So, You can represent CollectionView data structure with extracted each element.

# LICENSE
[Conv](https://github.com/bannzai/Conv/) is released under the MIT license. See [LICENSE](https://github.com/bannzai/Conv/blob/master/LICENSE.txt) for details.

Header logo is released [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/deed) license. Original design by [noainoue](https://github.com/noainoue).


