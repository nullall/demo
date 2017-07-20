//
//  Define.h
//  BinFen
//
//  Created by zhaoxy on 11-12-30.
//  Copyright (c) 2011年 TSoftime Company. All rights reserved.
//

//release的时候去掉debug的nslog
#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#define debugMethod() NSLog(@"%s", __func__)
//#else
//#define NSLog(...)
//#define debugMethod()
#endif

#define BundleID [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleIdentifier"]
//设置appdelegate
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication]delegate]
//设置屏幕布局
//屏幕适配
#define usableArea [UIScreen mainScreen].applicationFrame
#define screenArea [UIScreen mainScreen].bounds
//可用高度
#define usableWidth [UIScreen mainScreen].applicationFrame.size.width
#define usableHeight [UIScreen mainScreen].applicationFrame.size.height

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
//设置ios6/7/8 delta
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f)
#define IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f)
#define IOS_9 ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f)
#define IOS_10 ([[[UIDevice currentDevice] systemVersion] floatValue]>=10.0f)

//设置屏幕比例差
#define IPhone_Small ([[NSString stringWithFormat:@"%.2f",([[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] bounds].size.height)]isEqualToString:@"0.67"] ? YES : NO)
#define IPhone_Big ([[NSString stringWithFormat:@"%.2f",([[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] bounds].size.height)]isEqualToString:@"0.56"] ? YES : NO)
#define IPad ([[NSString stringWithFormat:@"%.2f",([[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] bounds].size.height)]isEqualToString:@"0.75"] ? YES : NO)

#define RGBA(r,g,b,a)                   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define xNavCHeight        64.0
#define xTabBarHeight                   49.0

#define SideViewWidth 100
#define SideMenuDefaultMenuWidth screenWidth-SideViewWidth

#define xNavViewColor                     RGBA(80, 0, 5, 1)
#define xAppBgColorBlack                     RGBA(12, 12, 12, 1)
#define xAppBgColorGray                     RGBA(212, 212, 212, 1)
#define xSeparateLineColor              RGBA(178, 178, 178, 1)
#define xGrayTextColor                  RGBA(146, 146, 146, 1)

#define titleColor RGBA(235, 79, 56, 1)
#define titleColorBlue RGBA(00, 92, 255, 1)
#define mainForeColor RGBA(50, 217, 207, 1)

#define EnabledColor [UIColor colorWithHexString:@"0B85E8"]
#define UnableColor [UIColor colorWithHexString:@"C2C2C2"]

#define xNotificationShowMenu                   @"xNotificationShowMenu"


//tabbar高度
#define XIITarbarHeight 58

//tabbar高度
#define DeviceInfoViewH 125


