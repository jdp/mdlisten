@import AppKit;
@import Foundation;

#import "QueryListener.h"

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

int main() {
    @autoreleasepool {
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        NSRange predicateArgsRange = NSMakeRange(1, [args count] - 1);
        NSString *predicate = [[args subarrayWithRange:predicateArgsRange] componentsJoinedByString:@" "];

        QueryListener *listener = [[[QueryListener alloc] initWithResultHandler:^(NSMetadataItem *item) {
            NSPrint(@"%@", [item valueForAttribute:@"kMDItemPath"]);
        }] autorelease];

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
