[![CocoaPods](https://img.shields.io/cocoapods/v/ElegantTableView.svg)](https://github.com/stackhou/ElegantTableView.git)

# ElegantTableView
优雅的创建TableView

### Cocoapods

a. Add ElegantTableView to your Podfile. </br>

```bash
	pod 'ElegantTableView'
```

b. Run

```bash
  	pod install 
```


### Carthage

a. Add ElegantTableView to your Cartfile. </br>

```bash
    github "stackhou/ElegantTableView"
```

b. Run 

```bash
    carthage update
```
c. Follow the rest of the [standard Carthage installation instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add ElegantTableView to your project.


## Use </br>

```objc

    NSArray *dataSources = @[@"你", @"我", @"他", @"1", @"2", @"3"];
    UITableView *tableView = [[ElegantTableViewGenerator shareInstance] createWithFrame:self.view.bounds titles:dataSources subTitles:nil rowHeight:44 didSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"点击TableView-->%ld", (long)indexPath.row);
    } didScrollBlock:^(UIScrollView *tableView, CGPoint contentOffset) {
        NSLog(@"滚动TableView-->%@", NSStringFromCGPoint(contentOffset));
    }];
    
    [self.view addSubview:tableView];
   
```
