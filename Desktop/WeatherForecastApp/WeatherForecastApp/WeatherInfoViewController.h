//
//  ViewController.h
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ConnectionClass.h"
#import "WeatherInfoDetailArrayViewController.h"

@interface WeatherInfoViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,connectionDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITableView *weatherTableView;

@end

