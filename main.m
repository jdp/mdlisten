#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

static void NSPrint(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    fprintf(stdout, "%s\n", [string UTF8String]);
    fflush(stdout);

    [string release];
}

static void NSPrintErr(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    fprintf(stderr, "%s\n", [string UTF8String]);
    fflush(stderr);

    [string release];
}

@interface LWListener : NSObject <NSMetadataQueryDelegate> {
    NSMetadataQuery *_query;
}

- (void)startListening:(NSString *)predicate;
- (void)queryNotification:(NSNotification *)notification;

@end

@implementation LWListener

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_query.isStarted) {
        [_query stopQuery];
    }
    _query.delegate = nil;
    [_query release];
    [super dealloc];
}

- (id)init {
    if ((self = [super init])) {
        _query = [[NSMetadataQuery alloc] init];
        _query.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryNotification:) name:NSMetadataQueryDidUpdateNotification object:_query];
    }
    return self;
}

- (void)startListening:(NSString *)predicate {
    if (_query.isStarted) {
        [_query stopQuery];
    }
    _query.predicate = [NSPredicate predicateWithFormat:predicate];
    [_query startQuery];
}

- (void)queryNotification:(NSNotification *)notification {
    for (id item in [notification.userInfo objectForKey:(NSString *)kMDQueryUpdateAddedItems]) {
        NSPrint(@"%@", [item valueForAttribute:@"kMDItemPath"]);
    }
}

@end

int main() {
    @autoreleasepool {
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        NSRange predicateArgsRange = NSMakeRange(1, [args count] - 1);
        NSString *predicate = [[args subarrayWithRange:predicateArgsRange] componentsJoinedByString:@" "];
        LWListener *listener = [[[LWListener alloc] init] autorelease];
        @try {
            [listener startListening:predicate];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }
        @catch (NSException *e) {
            if ([e.name isEqualToString:NSInvalidArgumentException]) {
                NSPrintErr(@"invalid query: %@", predicate);
            } else {
                NSPrintErr(@"crash: %@", e);
            }
        }
    }
    return 0;
}
