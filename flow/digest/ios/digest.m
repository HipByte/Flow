#import "digest.h"
#include <CommonCrypto/CommonDigest.h>

struct FlowDigestOpaque {
    void *ctx;
    int (*init)(void *);
    int (*update)(void *, const void *, long);
    int (*final)(unsigned char *, void *);
    int digest_len;
};

@implementation FlowDigest

#define FLOW_OPAQUE ((struct FlowDigestOpaque *)_opaque)

- (id)initWithAlgo:(NSString *)algo
{
    self = [self init];
    if (self == nil) {
	return nil;
    }

    struct FlowDigestOpaque *opaque = (struct FlowDigestOpaque *)
	malloc(sizeof(struct FlowDigestOpaque));
    assert(opaque != NULL);

#define INIT_OPAQUE(algo) \
    opaque->ctx = (void *)malloc(sizeof(CC_##algo##_CTX)); \
    assert(opaque->ctx != NULL); \
    opaque->init = (int (*)(void *))CC_##algo##_Init; \
    opaque->update = (int (*)(void *, const void *, long))CC_##algo##_Update; \
    opaque->final = (int (*)(unsigned char *, void *))CC_##algo##_Final; \
    opaque->digest_len = CC_##algo##_DIGEST_LENGTH;

    if ([algo isEqualToString:@"SHA1"]) {
	INIT_OPAQUE(SHA1)
    }
    else if ([algo isEqualToString:@"MD5"]) {
	INIT_OPAQUE(MD5)
    }
    else {
	NSLog(@"incorrect algorithm name %@", algo);
	free(opaque);
	abort();
    }

#undef INIT_OPAQUE
    _opaque = opaque;
    [self reset];
    return self;
}

- (void)dealloc
{
    free(FLOW_OPAQUE->ctx);
    free(_opaque);
    _opaque = NULL;
    [super dealloc];
}

+ (id)digestWithAlgo:(NSString *)algo
{
    return [[[FlowDigest alloc] initWithAlgo:algo] autorelease];
}

- (void)update:(NSData *)data
{
    FLOW_OPAQUE->update(FLOW_OPAQUE->ctx, [data bytes], [data length]);
}

- (void)reset
{
    FLOW_OPAQUE->init(FLOW_OPAQUE->ctx);
}

- (NSData *)digest
{
    unsigned char *md = (unsigned char *)malloc(FLOW_OPAQUE->digest_len);
    assert(md != NULL);

    FLOW_OPAQUE->final(md, FLOW_OPAQUE->ctx);

    return [NSData dataWithBytesNoCopy:md length:FLOW_OPAQUE->digest_len];
}

@end

