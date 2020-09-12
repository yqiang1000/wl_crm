//
//  UIApplication+ShortCut.m
//  ShourCut
//
//  Created by mac  on 14-1-14.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "UIApplication+ShortCut.h"

@implementation UIApplication (ShortCut)


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
- (BOOL)isPirated
{
    
    if ([[[NSBundle mainBundle] infoDictionary]
         objectForKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"CodeResources"])
    {
        return YES;
    }
    
    if (![self _fileExistMainBundle:@"ResourceRules.plist"]) {
        return YES;
    }
    
    //you may test binary's modify time ...but,
    //if someone want to crack your app, this method is useless..
    //you need to change this method's name and do more check..
    return NO;
}


///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
- (BOOL)_fileExistMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
@end
