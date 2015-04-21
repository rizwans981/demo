//
//  ViewController.m
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/16/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "WeatherInfoViewController.h"
#import "MBProgressHUD.h"

@interface WeatherInfoViewController ()
{
    UITapGestureRecognizer *tap;
    ConnectionClass *con;
    NSMutableArray *arrayOfDay;
    MBProgressHUD *hud;
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    NSMutableArray *dayNameArray;
    BOOL flag;
}
@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation WeatherInfoViewController
@synthesize locationManager=_locationManager;

- (void)viewDidLoad {
    flag = YES;
    
     //code for getting current day number
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int weekDay = (int)[component weekday];
    dayNameArray = [self dayNames:weekDay];
//*******************************************
    
    [super viewDidLoad];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background.jpg"].CGImage;
    
    [self.weatherTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:120/255.0 green:25/255.0 blue:34/255.0 alpha:1]];
    
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    arrayOfDay = [[NSMutableArray alloc]init];
    con = [[ConnectionClass alloc]init];
    con.delegate=self;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //code for geeting lat long of current device
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager setDelegate:self ];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
 
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCurrentCityWeatherInfo
{
    //code for getting city name from lat long
   
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    NSLog(@"currentLocation.coordinate.latitude%f",currentLocation.coordinate.latitude);
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             [hud hide:YES];
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         else
         {
             CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
             NSString *countryCode = myPlacemark.ISOcountryCode;
             NSString *countryName = myPlacemark.country;
             NSString *cityname = myPlacemark.locality;
             
             NSLog(@"My country code: %@ and countryName: %@", countryCode, countryName);
             self.cityLabel.text = [NSString stringWithFormat:@"City : %@  Country : %@",cityname,countryName];
             
             
             [con getWeatherDataForCity:cityname];
         }
         
        
         
     }];
    
}
#pragma mark TableView DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell1";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    int i =(int) indexPath.section+1;
    
    cell.textLabel.text = [dayNameArray objectAtIndex:indexPath.section];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"Day %d",i];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.imageView.image =[UIImage imageNamed:@"unnamed.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text =[NSString stringWithFormat:@"Today"];

    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [arrayOfDay count];
}
#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherInfoDetailArrayViewController * detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherInfoDetailArrayViewController"];
    
    detailVC.wetherDict = [arrayOfDay objectAtIndex:indexPath.section];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
    
}
#pragma mark SearchBar Delegate



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *rawString = [self.searchBar text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    
    
    if (![trimmed length] == 0)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        // hud.labelText = @"Uploading";
        [hud show:YES];
        [con getWeatherDataForCity:self.searchBar.text];
    }
    
    
    [self.view removeGestureRecognizer:tap];
    [searchBar resignFirstResponder];
}



- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.weatherTableView reloadData];
    [_searchBar resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    return YES;
}


-(void)dismissKeyboard
{
    NSString *rawString = [self.searchBar text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    
    
    if (![trimmed length] == 0)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        // hud.labelText = @"Uploading";
        [hud show:YES];
        [con getWeatherDataForCity:self.searchBar.text];
    }
    [self.view removeGestureRecognizer:tap];
    [self.view endEditing:YES];
    
    [self.weatherTableView reloadData];
}
#pragma mark ConnectionDelegate

- (void)receivedData:(NSDictionary *)responseDict
{
     NSLog(@"countryname =%@" , [[responseDict valueForKey:@"city"] valueForKey:@"country"]);
      NSLog(@"countryname =%@" , responseDict);
    [hud hide:YES];
    
    if ([[responseDict valueForKey:@"cod"] isEqualToString:@"404"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter correct city name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alertView.tag =1;
        [alertView show];
    }
    else{
        [arrayOfDay removeAllObjects];
        [arrayOfDay addObjectsFromArray:[responseDict valueForKey:@"list"]];
        NSString *cityname = [[responseDict valueForKey:@"city"] valueForKey:@"name"];
        NSString *countryname = [[responseDict valueForKey:@"city"] valueForKey:@"country"];
        
        self.cityLabel.text = [NSString stringWithFormat:@"City : %@  Country : %@",cityname,countryname];
        [self.weatherTableView reloadData];
    }
    
}
-(void)failToReciveData:(NSString *)errorTitle errorMessage:(NSString *)message
{
    [hud hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}

#pragma mark location manger delgate method

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location manager works");
    
    // Current Location
    currentLocation = [locations objectAtIndex:0];
    
    //currentLocation.coordinate.latitude=47.574435;
    
    if (flag == YES&&locations.count>0) {
        [self getCurrentCityWeatherInfo];
        flag = NO;
    }
    
    //    latLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    //    longLabel.text = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    //[self.mapView addAnnotation:point];
    
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error %@",[error localizedDescription]);
    self.cityLabel.text =@"Location manager fails";
    NSLog(@"Location manager fails");
}
#pragma mark UIAlerView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
       if(alertView.tag == 1)
      {
         [self.searchBar becomeFirstResponder];
      }
    
}
-(NSMutableArray *)dayNames:(int)dayNumber
{
    
    if (dayNumber == 2)
    {
        return   [[NSMutableArray alloc]initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
    }
    else if (dayNumber == 3)
    {
        
        
        return  [[NSMutableArray alloc]initWithObjects:@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",nil];
    }
    else if   (dayNumber == 1) {
        return [[NSMutableArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"WednesDay",@"Thursday",@"Friday",@"Saturday", nil];
    }
    
    else if(dayNumber == 4)
    {
        return [[NSMutableArray alloc]initWithObjects:@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",nil];
    }
    else if(dayNumber == 5)
    {
        return [[NSMutableArray alloc]initWithObjects:@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",nil];
    }
    
    
    else if(dayNumber == 6)
    {
        return [[NSMutableArray alloc]initWithObjects:@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",nil];
        
    }

    else if(dayNumber == 7)
    {
        return [[NSMutableArray alloc]initWithObjects:@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",nil];
    }
    return nil;
}
@end
