//
//  ConnectionClass.m
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ConnectionClass.h"

@implementation ConnectionClass

- (void)getWeatherDataForCity:(NSString *)cityName
{
    NSString * statement = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=7d864241d52b64d8329d46305089847a",cityName];
    
    
    
    self.responseData = [NSMutableData data];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:statement]];
// connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
//   
    id connec= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    connec = nil;
}

#pragma - mark  NSURl Connection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
            [_responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseData = nil;
    
  [_delegate failToReciveData:@"Connection Error!" errorMessage:@"Network Failed To Respond"];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
            NSDictionary *JsonDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:nil];
            
            // CityModel * cityM = [[CityModel alloc] init];
            
            
            
            
            
            
            if (JsonDict.count>0) {
                
                if ([_delegate respondsToSelector:@selector(receivedData:)]) {
                    
                    [_delegate receivedData:JsonDict];
                }
                
            }
            
            else{
    
    
            [_delegate failToReciveData:@"Connection Error!" errorMessage:@"Network Failed To Respond"];
            
    
        
            }
}

@end
