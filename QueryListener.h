@import Foundation;

typedef void (^ ResultHandler)(NSMetadataItem *);

@interface QueryListener : NSObject <NSMetadataQueryDelegate> {
    NSMetadataQuery *_query;
    ResultHandler _resultHandler;
}

- (id)initWithResultHandler:(ResultHandler)resultHandler;
- (void)startListening:(NSString *)predicate;
- (void)queryNotification:(NSNotification *)notification;

@end
