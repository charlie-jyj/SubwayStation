# 지하철 도착 정보 앱

## 구현

### 1) 구현 기능

- 지하철 역 검색화면 구현
  - UINavigationItem에 UISearchController 추가
  - UITableView
- 도착 정보 화면 구현
- 비동기 처리 
- 지하철 도착 정보 가져오는 네트워크 통신 구현

### 2) 기본 개념

#### (1) UISearchController

> A view controller that manages the display of search results based on interactions with a search bar.

use a serach controller to provide a standard search experience of the contents of another view controller. when the user interacts with a UISearchBar, the search controler coordinates with a search results controller to display the search results.

<https://developer.apple.com/documentation/uikit/uisearchcontroller>

- init(searchResultsController: UIViewController?)
  - initialize and returns a search
- var searchBar: UISearchBar
- var searchResultsController
  - The view controller that displays the results of the search

```swift
```

##### UISearchBarDelegate

> 사용자의 입력을 받는 UI component의 대다수는 delegate를 통해 사용자의 입력 및 동작을 포착할 수 있다.
```swift
override func viewDidLoad() {
    searchContorller.searchBar.delegate = self
}

extension viewController: UISearchBarDelegate {
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}
```

#### (2) UITableView

```swift
private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
}()

extension viewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {}
}
```

#### (3) 비동기 처리

1. Notification Center
2. Delegate Pattern
3. Closure
4. RxSwift
5. Conbine ios 14+



### 3) 새롭게 알게 된 것

#### 🧸 UIControllerView가 가지고 있는 UINavigation 관련 variable

- navigaitonController
  - navigaitonController?.navigationBar
    - prerfersLargeTitles
- navigationItem
  - title
  - searchController: the search controller to integrate into your navigation interface 

#### 🔨 tableView 설정을 했더니 SearchBar가 보이지 않는다.

=> numberOfRowsInSection 의 값이 0이 아니어서 tableView가 SearchBar를 가렸다.
동적으로 할당된 값을 가지는 변수로 행의 개수를 관리하자. 
(editing 하지 않을 때 search bar가 보이게 하기 위해선 매번 초기화가 필요함)

```swift
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        numberOfRows = dataList.count
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        numberOfRows = 0
    }
}

```

#### ❓ tableView:numberOfRowsInSection 은 언제 call 되는 걸까?

- for the first time when table is loaded
- the time you reload the table data
- the time you add/update/delete your row or sections dynamically

<https://stackoverflow.com/questions/16914020/when-is-tableviewnumberofrowsinsection-called-in-uitableview/16914049>

#### 🔅 collectionView Cell에 radius shadow 주기

```swift
contentview.backgroundColor = .systemBackground // 이게 없으면 shadow 가 눈에 보이지 않더라 (배경값 기준으로 shadow가 정해지기 때문)

backgoundColor = .systemBackground // contentview 생략 가능
layer.contentRadious = 10  // shadow만 둥글면 안 되고 cell 자체도 둥글어야 함
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.2  // 그림자 색상을 gray로 만들기 위해
layer.shadowRadius = 10
```

#### 〽️ 화면이 전환 되면서 navigation bar의 이름을 바꾸고 싶어

```swift
overrid func viewDidLoad() {
super.viewDidLoad()
navigationItem.title = "name"

//navigationController?.navigationItem.title = "wrongAccess" // 이건 원하는 결과가 안 나옴
}
```

##### ❗️ 처음에 내가 원하는 결과가 안 나왔던 이유

navigationController의 navigationItem 에 title 을 달게 아니라
내가 현재 보고 있는 controller의 navigationitem 에 title을 달아야하기 때문이다.
You are changing the navigation item of the navigation controller, but that will never be seen unless the navigation controller was inside another navigation controller.
you should set the title in the view controller you add to your navigation controller.

<https://stackoverflow.com/questions/2040415/uinavigationcontroller-title-is-not-displayed>

navigationItem vs navigationBar

- UINavigationBar: Navigational controls that display in a bar along the top of the screen, usually in conjunction with a navigation controller containing buttons for navigating within a hierarchy of screens. the primary components are a left button, and an optional right button. 

<img src="https://docs-assets.developer.apple.com/published/dde7452123/3abba22e-4aef-47dd-b4e2-a9965c424338.png">

- UINavigationItem: the items that a navigation bar displays when the associated view contoller is visible. when building a navigation interface, each view controller that you push onto the navigation stack must have a UINavigationItem object that contains the buttons and views you wnat to display in the navigation bar. 

the navigation item must provide a title to display when the view controller is topmost on the navigation stack. the item can also contain additional buttons to display on the right side of the navigation bar.

<img src="https://docs-assets.developer.apple.com/published/dde7452123/3abba22e-4aef-47dd-b4e2-a9965c424338.png">

#### 🍔 UIRefreshControl

> UICollectionView와 함께 사용된다.

A standard control that can initiate the refreshing of a scroll view's contents.
which is a standard control that you attach to any UIScrollView objtct, including table views and collection views. When the user drags the top of the scrollable content area downward, the xcroll view reveals the refresh control, befins animating its progress indicator, and notifies your app. you use that notification to update your content and dismiss the refresh control.

```swift
func configureRefreshControl () {
   // Add the refresh control to your UIScrollView object.
   myScrollingView.refreshControl = UIRefreshControl()
   myScrollingView.refreshControl?.addTarget(self, action:
                                      #selector(handleRefreshControl),
                                      for: .valueChanged)
}
    
@objc func handleRefreshControl() {
   // Update your content…

   // Dismiss the refresh control.
   DispatchQueue.main.async {
      self.myScrollingView.refreshControl?.endRefreshing()
   }
}
```

<https://developer.apple.com/documentation/uikit/uirefreshcontrol>
<img src="https://docs-assets.developer.apple.com/published/a548e8f236/refresh-control~dark@2x.png">

#### 🍉 info.plist 에서 앱 통신 허용 값 추가하기
왜 이걸 전에는 한 기억이 없을까?

- App Transport Security Settings
  - Allow Arbitrary Loads : TRUE
