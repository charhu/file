
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

// 协议里面也可以添加多个，表示 demoDelegate 遵守多个协议类型
@protocol demoDelegate <NSObject, NSCacheDelegate, UITableViewDelegate>

// 不写 required 修饰，或者写 @required 修饰，都是必须要实现的，否则是可选类型
@property (copy, nonatomic) NSString *number;

// 不写 required 修饰，或者写 @required 修饰，都是必须要实现的，否则是可选类型
- (void)testInstanceClick1:(NSString *)name;
+ (void)testClassClick1:(NSString *)name;

@optional
- (void)testInstanceClick2:(NSString *)name;
+ (void)testClassClick2:(NSString *)name;

@end

@interface Man : NSObject<demoDelegate>
@property (assign, nonatomic) id<demoDelegate> delegate;
@end

@implementation Man

// 如果声明了属性，可采用方案1
//@synthesize number;

// 如果声明了属性，也可采用方案2
- (void)setNumber:(NSString *)number{
    _delegate.number = number;
}
- (NSString *)number{
    return _delegate.number;
}

// 不写 required 修饰，或者写 @required 修饰，都是必须要实现的，否则是可选类型
+ (void)testClassClick1:(NSString *)name {
}

- (void)testInstanceClick1:(NSString *)name {
}

@end




struct _protocol_t {
    void * isa;  // NULL
    const char *protocol_name;     // 协议名称
    const struct _protocol_list_t * protocol_list; // 支持的协议
    const struct method_list_t *instance_methods;   // 必须要实现的实例方法
    const struct method_list_t *class_methods;      // 必须要实现的类方法
    const struct method_list_t *optionalInstanceMethods; // 可选的要实现的实例方法
    const struct method_list_t *optionalClassMethods;   // 可选的要实现的类方法
    const struct _prop_list_t * properties; // 属性列表
    const unsigned int size;  // sizeof(struct _protocol_t)
    const unsigned int flags;  // = 0
    const char ** extendedMethodTypes;
};


int main(int argc, char *argv[]){

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
