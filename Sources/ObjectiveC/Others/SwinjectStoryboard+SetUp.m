//
//  SwinjectStoryboard+SetUp.m
//  SwinjectStoryboard
//
//  Created by Mark DiFranco on 2017-05-27.
//  Copyright © 2017 Swinject Contributors. All rights reserved.
//

#import <Foundation/Foundation.h>

__attribute__((constructor)) static void swinjectStoryboardSetupEntry(void) {
    Class swinjectStoryboard = NSClassFromString(@"SwinjectStoryboard");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([swinjectStoryboard respondsToSelector:@selector(configure)]) {
        [swinjectStoryboard performSelector:@selector(configure)];
    }
#pragma clang diagnostic pop
}

