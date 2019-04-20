//
//  HSMain.m
//  HelloSketch
//
//  Created by Kevin Gutowski on 1/3/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import "HSMain.h"
@import AppKit;

#define HSLog(fmt, ...) NSLog((@"HelloSketch (Sketch Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
@implementation HSMain
- (NSString *)helloText {
    HSLog(@"Reading helloText");
    return @"Hey there, sending signal from HSMain, over.";
}

- (NSArray *)bridgeArray:(CFArrayRef *)cfarray {
    NSArray *array = CFBridgingRelease(cfarray);
    return array;
}

- (NSDictionary *)bridgeDict:(CFDictionaryRef *)cfdict {
    NSDictionary *dict = CFBridgingRelease(cfdict);
    return dict;
}
@end
