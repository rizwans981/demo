//
//  WeatherInfoDetailArrayViewController.h
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherInfoDetailArrayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property(strong,nonatomic)NSDictionary *wetherDict;
@end
