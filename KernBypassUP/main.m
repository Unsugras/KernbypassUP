//
//  main.m
//  KernBypassUP
//
//  Created by A2 on 2020/6/5.
//  Copyright © 2020 A2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@import CoreTelephony;
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
         [[NSUserDefaults standardUserDefaults] setObject:@"alpine" forKey:@"defaultpwd"];
            [[NSUserDefaults standardUserDefaults] setObject:@"2222" forKey:@"defaultport"];
        }
        
        
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
