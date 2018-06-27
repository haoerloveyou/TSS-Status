//
//  ViewController.h
//  TSS-Signing
//
//  Created by cole cabral on 2018-06-13.
//  Copyright © 2018 cole cabral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
-(void)backgroundUpdate:(void (^)(UIBackgroundFetchResult))completionHandler;

@end

