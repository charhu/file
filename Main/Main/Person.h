//
//  Person.h
//  Main
//
//  Created by MacPro on 2020/9/11.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    @public
    NSString *_name;
    NSMutableString *_age;
    
}

//@property (strong, nonatomic) NSString *name;
//@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSMutableString *age;

@end

NS_ASSUME_NONNULL_END
