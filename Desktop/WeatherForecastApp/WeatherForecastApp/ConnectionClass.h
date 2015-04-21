//
//  ConnectionClass.h
//  WeatherForecastApp
//
//  Created by Shaikh Rizwan on 4/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol connectionDelegate <NSObject>
@required
- (void)receivedData:(NSDictionary *)responseDict;     //The method performs the action of receiving the data
-(void)failToReciveData:(NSString *)errorTitle errorMessage:(NSString *)message; //responseFailedWithError  //The method gets invoked on failure of receiving the data
@end



@interface ConnectionClass : NSObject<NSURLConnectionDelegate>
{
    NSURLConnection * connection;
    
}


@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, unsafe_unretained) id <connectionDelegate> delegate;


- (void)getWeatherDataForCity:(NSString *)cityName;
@end
