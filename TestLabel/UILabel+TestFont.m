//
//  UILabel+TestFont.m
//  TestBlock
//
//  Created by zhengzeqin on 16/3/31.
//  Copyright © 2016年 com.injoinow. All rights reserved.
//

#import "UILabel+TestFont.h"
#import <objc/runtime.h>
@implementation UILabel (TestFont)

+ (void)load{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//
        SEL originalSelector = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(testAwakeFromNib);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        BOOL didAddMethod = class_addMethod(self, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(swizzledMethod));
        }else{
            [self exchangeSEL:@selector(testAwakeFromNib) now:@selector(awakeFromNib)];
        }
        
    });
    
}

+ (void)exchangeSEL:(SEL)originSEL now:(SEL)nowSEL{
    //    IMP
    method_exchangeImplementations(class_getInstanceMethod(self, originSEL), class_getInstanceMethod(self, nowSEL));
    
}

- (void)awakeFromNib{

}


- (void)testAwakeFromNib{
    [self testAwakeFromNib];
    self.font = [UIFont systemFontOfSize:10];
}

@end
