#import "QueryListener.h"

@implementation QueryListener

- (id)initWithResultHandler:(ResultHandler)resultHandler {
    if ((self = [super init])) {
        _resultHandler = resultHandler;
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
        _resultHandler(item);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_query.isStarted) {
        [_query stopQuery];
    }
    _query.delegate = nil;
    [_query release];
    [_resultHandler release];
    [super dealloc];
}

@end
