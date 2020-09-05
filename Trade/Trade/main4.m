
#import <Foundation/Foundation.h>

#include <objc/runtime.h>
#include <malloc/malloc.h>

#import "Demo.h"

// 冒泡排序
/*
1、两层for循环嵌套，外层遍历次数循环，内层逐个比较找到最大值循环
2、需要执行的循环次数等于，总集合元素个数-1
3、比较次数等于 （总集合元素个数-1）的阶层！
*/

void paoSort(){
    
    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6", nil];
    
    int count = 0;
    for(int i = 0; i< (result.count - 1); i ++){
                
        for (int j = 1; j < (result.count - i); j ++){
            
            int beginnum = [result[ j - 1 ] intValue];
            int endnum = [result[j] intValue];
            
            if (beginnum > endnum) {
                NSString *temp = result[ j - 1 ];
                result[ j - 1 ] = result[j];
                result[j] = temp;
            }
            
            count++;
        }
            
//        NSLog(@"result : %@  count：%d", result, count);
        
//        count = 0;
    }
    NSLog(@"result : %@  count：%d", result, count);
}

// 插入排序
/* 下面的写法，近似希尔排序的思想，即减少了数据移位交换的频次 */
void insertSort1(){
    NSMutableArray *result = [NSMutableArray array];
    NSArray *arr = @[@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6"];
    [result insertObject:arr[0] atIndex:0];
    
           
    for(int i = 1 ; i <arr.count; i ++){
        
        int nextnum = [arr[i] intValue];
                                                
        int lastnum = [result.lastObject intValue];
        if (nextnum >= lastnum) {
            [result insertObject:arr[i] atIndex:result.count];
            
        }else{
            unsigned long j = result.count - 1;
            if (j == 0) {
                [result insertObject:arr[i] atIndex:j];
                
            }else{
                
                while (1) {
                            
                    int previousnum = [result[j] intValue];
                    if (nextnum  < previousnum) {
                        j--;
                    }else{
                        [result removeObject:arr[i]];
                        [result insertObject:arr[i] atIndex:(j+1)];
                        break;
                    }
                }
            }
        }
    }
    NSLog(@"result : %@", result);
}

// 插入排序
void insertSort2(){
        
    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6", nil];
    
    for(int i = 1 ; i <result.count; i ++){
        
        int nextnum = [result[i] intValue];
        
        int lastnum = [result[i-1] intValue];
        
        if (nextnum < lastnum) {
            int j = i - 1;
            if (j == 0) {
                [result exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                
            }else{
                while (1) {
                    int previousnum = [result[j] intValue];
                    if (nextnum < previousnum && j > 0) {
                        [result exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                        j--;
                    }else{
                        break;
                    }
                }
            }
        }
        
        NSLog(@"result : %@", result);
    }
}

// 插入排序
/*
1、从索引1开始，每个元素逐个跟前一个元素进行对比，根据对比结果进行位置调整
2、需要执行的循环次数等于，总集合元素个数-1
*/
void insertSort(){
        
    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6", nil];
    
    for(int i = 1 ; i <result.count; i ++){
        
        int nextnum = [result[i] intValue];
    
        int j = i - 1;
        while (1) {
            int previousnum = [result[j] intValue];
            if ( nextnum < previousnum ) {
                [result exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
                j--;
                if (j <= 0) {
                    break;
                }
            }else{
                break;
            }
        }
    }
    NSLog(@"result : %@", result);
}

// 折半插入排序
/*
1、从索引0开始，设定索引 low=0,high=1,mid=(low+high)/2, mid 可以向上取整，
2、拿arr[mid] 跟后面的high索引元素进行对比，根据对比结果进行位置调整
3、后面元素依次逻辑，循环执行第1步，第2步，[low=0,high=2],[low=0,high=3],[low=0,high=4]...
4、需要执行的循环次数等于，总集合元素个数-1
*/
void BInsertSort(){
    int a[8] = {3,1,7,5,2,4,9,6};
    int size = 8;
    int i,j,low = 0,high = 0,mid = 0;
    int temp = 0;
    for (i=1; i<size; i++) {
                        
        low=0;
        high=i-1;
        temp=a[i];
        
        //采用折半查找法判断插入位置，最终变量 low 表示插入位置
        while (low<=high) {
            mid=(low+high)/2;
            if (a[mid]>temp) {
                high=mid-1;
            }else{
                low=mid+1;
            }
        }
        
        //有序表中插入位置后的元素统一后移
        for (j=i; j>low; j--) {
            a[j]=a[j-1];
        }
        a[low]=temp;//插入元素

        printf("%d：",i);
        for(int j=0; j<8; j++){
            printf("%d",a[j]);
        }
        printf("\n");
    }
}


int sum(int num){   // 4.3.2.1....
    int result = num;
    if (num > 0) {
        result = result + sum(num - 1);
    }

    return result;
}

// 堆排序
/*
1、堆排序其实可以理解成插入时的逆运算
2、先构造小堆或者大堆结构
3、删除根节点，并将其存储到新的有序集合中
4、删除后动态平衡还原堆结构，
5、重复循环执行第2步，第3步，
6、当删光了后，最后的集合，就是要的排序了。
//
 
*/
void heapSort(){
    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6", nil];

}

// 二分查找
/*
1、前提是二叉查找有序树，或者是有序的顺序表集合,如数组
2、从索引0开始，设定索引 low=0,high=arr.count-1,mid=(low+high)/2, mid 可以向上取整，
3、拿arr[mid] 跟要查找的元素进行对比，根据对比结果锁定查找范围
4、后面元素依次逻辑，循环执行第1步，第2步，[low=mid,high=arr.count-1] 或 [low=mid,high=mid]
5、需要执行的循环次数最大值等于树的高度，最小值1
*/
NSNumber* getindex(int num){
    
    NSArray *tempArr = [NSArray arrayWithObjects:@5,@13,@19,@21,@37,@56,@64,@75,@80,@88,@92, nil];
        
    NSUInteger endindex = tempArr.count - 1;
    NSUInteger midindex = tempArr.count / 2;
    
    for (NSUInteger i = 0; i < tempArr.count; i ++) {
                        
        NSLog(@"i:%ld, midindex:%ld, endindex:%ld", i, midindex, endindex);
        
        int midnum = [[tempArr objectAtIndex:midindex] intValue];
        if (midnum == num) {
            return [NSNumber numberWithUnsignedLong:midindex];
            
        }else if (midindex == endindex){
            return nil;
            
        }else if (midnum < num){
            midindex = (midindex + 1 + endindex) / 2;
            
        }else{
            endindex = midindex - 1;
            midindex = endindex / 2;
        }
    }
    
    return nil;
}


// 希尔排序
/*
 
 */
void shellSort(){
    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"3", @"1", @"7",@"5",@"2",@"4",@"9",@"6", nil];
}

// 快速排序
/*
1、主要是采用递归、分治算法的思想来解决这个问题，先不断拆分，1=》2=》4=》。。。最终的成品就是结果
2、拆分主要用到的手段就是递归，核心思路是，找比基准小的，放基准左边，比它大的，放右边
3、传参使用三个，数组源，起点索引，结束索引，以起点值做基准，左索引 L 指针，右索引 R 指针
4、L 指针，负责从左往右扫描，任务是找到比基准大的，就放到位置 R 上，比基准小或相等的，则不变，
同时继续 L 指针加1，直到找到比基准大的值后结束此次 L 扫描，同时也要求，L<R, 即左扫描一定不能穿过右扫描，
 否则代表无效扫描；
5、R 指针，负责从右往左扫描，任务是找到比基准小的，就放到位置 L 上，比基准大或相等的，则不变，
 同时继续 R 指针减1，直到找到比基准小的值后结束此次 R 扫描，同时也要求，L<R, 即右扫描一定不能穿过左扫描，
  否则代表无效扫描；
6、当出现LR碰头重合，说明一轮扫描完毕。就把基准放到该重合点。
7、开启递归分解，重复上面 3，4，5，6
*/
void quickSort1(NSMutableArray *result, int L, int R){
    
    NSLog(@"result : %@, L：%d, R：%d)", result, L, R);
    
    if (L >= R) {
        return;
    }
    
    int Lp = L;
    int Rp = R;
    
    NSString *basic = result[L];
    
    while (Lp < Rp) {
        
        //        NSLog(@"从右往左：<<<==== Lp：%d, Rp：%d", Lp, Rp);
        
        NSString *right = result[Rp];
        while (right.intValue >= basic.intValue && Lp < Rp){
            Rp --;
            right = result[Rp];
        }
        
        if (right.intValue < basic.intValue && Lp < Rp){
            result[Lp] = right;
            Lp++;
        }
        
        if (Lp == Rp) {
            result[Rp] = basic;
            break;
        }
        
//        NSLog(@"从左往右：====>>>Lp：%d, Rp：%d", Lp, Rp);
               
        NSString *left = result[Lp];
        while (left.intValue <= basic.intValue && Lp < Rp){
            Lp++;
            left = result[Lp];
        }
    
        if (left.intValue > basic.intValue && Lp < Rp) {
            result[Rp] = left;
            Rp --;
        }
        
        if (Lp == Rp) {
            result[Rp] = basic;
            break;
        }
    }
    
    quickSort1(result, L, Rp - 1);
    quickSort1(result, Rp + 1, R);
}

void quickSort(NSMutableArray *result, int L, int R){
    
    NSLog(@"result : %@, L：%d, R：%d)", result, L, R);
    
    if (L >= R) {
        return;
    }
    
    int Lp = L;
    int Rp = R;
    
    NSString *basic = result[L];
    
    while (Lp < Rp) {
        
        // 从右往左
        NSString *right = result[Rp];
        do{
            if (right.intValue < basic.intValue) {
                result[Lp] = right;

            }else{
                Rp--;
                if (Rp < 0) {
                    return;
                }
                right = result[Rp];

                if (right.intValue < basic.intValue) {
                    result[Lp] = right;
                }
            }
            NSLog(@"从右往左：<<<==== Lp：%d, Rp：%d", Lp, Rp);
        }while (right.intValue >= basic.intValue && Lp != Rp);
    

        // 从左往右
        NSString *left = result[Lp];
        do{
            if (left.intValue > basic.intValue) {
                result[Rp] = left;

            }else{
                Lp++;
                if (Lp > Rp) {
                    return;
                }
                left = result[Lp];

                if (left.intValue > basic.intValue) {
                    result[Rp] = left;
                }
            }
            NSLog(@"从左往右：====>>>Lp：%d, Rp：%d", Lp, Rp);
        }while(left.intValue <= basic.intValue && Lp != Rp);
        
        
        if (Lp == Rp) {
            result[Rp] = basic;
            break;
        }
    }
    
    quickSort(result, L, Rp - 1);
    quickSort(result, Rp + 1, R);
}


int main(int argc, char *argv[]){
    
    @autoreleasepool {
        NSObject *obj = [[NSObject alloc] init];
        
//        NSLog(@"isa：%ld", malloc_size((__bridge const void *)(object_getClass(obj)))); // 系统分配给子对象的内存空间大小
//
//        object_getIndexedIvars(demo);
//        object_getIvar(demo, <#Ivar  _Nonnull ivar#>);
//        objc_getProtocol(<#const char * _Nonnull name#>)
        
//        NSLog(@"NSObject：%ld", class_getInstanceSize([NSObject class]));  // NSObject 占用多少内存空间
//        NSLog(@"Demo：%ld", class_getInstanceSize([Demo class])); // 继承 NSObject 的子对象占用多少内存空间
//        NSLog(@"Demo：%ld", malloc_size((__bridge const void *)([[Demo alloc] init]))); // 系统分配给子对象的内存空间大小

//        paoSort();
//        insertSort();
//        BInsertSort();
        
//        insertSort1();
//        NSLog(@"递归：%d", sum(100));
        
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"3", @"5", @"5", @"8",@"1",@"2",@"2",@"9",@"4",@"7",@"6", nil];
//        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"19", @"97", @"09",@"17",@"01",@"08", nil];
//        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"6", @"1", @"2",@"7",@"9",@"3",@"4",@"5",@"8", nil];
        quickSort(arr, 0, (int)arr.count - 1);
    }
     
    return 0;
}
