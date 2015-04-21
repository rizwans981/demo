//
//  WeatherInfoDetailArrayViewController.m
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "WeatherInfoDetailArrayViewController.h"

@interface WeatherInfoDetailArrayViewController ()
{
    NSMutableDictionary *tempratureDict,*weathetDict;
}

@end

@implementation WeatherInfoDetailArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.contents = (id)[UIImage imageNamed:@"background.jpg"].CGImage;
    
    [self.infoTableView setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.title = @"Weather Information";
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    weathetDict = [[NSMutableDictionary alloc]init];
    tempratureDict = [[NSMutableDictionary alloc]init];
    
    [weathetDict setValue:[self.wetherDict valueForKey:@"clouds"] forKey:@"Clouds"];
    [weathetDict setValue:[self.wetherDict valueForKey:@"deg"] forKey:@"Degree"];
    [weathetDict setValue:[self.wetherDict valueForKey:@"humidity"] forKey:@"Humidity"];
    [weathetDict setValue:[self.wetherDict valueForKey:@"pressure"] forKey:@"Pressure"];
    [weathetDict setValue:[self.wetherDict valueForKey:@"speed"] forKey:@"Speed"];
    [weathetDict setValue:[[[self.wetherDict objectForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"] forKey:@"Rain"];
    
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"day"]forKey:@"Day"];
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"night"]forKey:@"Night"];
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"morn"]forKey:@"Morning"];
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"eve"]forKey:@"Evening"];
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"max"]forKey:@"Maximum"];
    [tempratureDict setValue:[[self.wetherDict objectForKey:@"temp"] valueForKey:@"min"]forKey:@"Minimum"];
    
    [self.infoTableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [weathetDict count];
    }
    else{
        return [tempratureDict count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell1";
    //3
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    int i =(int) indexPath.row+1;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Day %d",i];
    
    if (indexPath.section==0) {
        NSArray *keyArray = [weathetDict allKeys];
        NSArray *allValues =[weathetDict allValues];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[keyArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[allValues objectAtIndex:indexPath.row]];
    }
    else
    {
        NSArray *keyArray = [tempratureDict allKeys];
        NSArray *allValues =[tempratureDict allValues];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[keyArray objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[allValues objectAtIndex:indexPath.row]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headerView.layer.contents = (id)[UIImage imageNamed:@"cellbg.png"].CGImage;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((headerView.frame.size.width-250)/2,10,250,30)];
  
    titleLabel.textColor = [UIColor whiteColor];
    if (section == 0) {
         titleLabel.text =@"General Weather Information";
    }
    else{
        titleLabel.text = @"General Temprature Information";
    }
    [headerView addSubview:titleLabel];
    return headerView;
    
}// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
