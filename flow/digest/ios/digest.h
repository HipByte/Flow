#import <Foundation/Foundation.h>

@interface FlowDigest : NSObject
{
    void *_opaque;
}

+ (id)digestWithAlgo:(NSString *)algo;

- (void)update:(NSData *)data;
- (void)reset;
- (NSData *)digest;

@end
