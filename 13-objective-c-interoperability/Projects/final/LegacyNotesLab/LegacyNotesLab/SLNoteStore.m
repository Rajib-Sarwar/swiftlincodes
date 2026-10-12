#import "SLNoteStore.h"
NSString * const SLNoteErrorDomain = @"com.swiftlin.LegacyNotes";
@implementation SLNote
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title
                              body:(NSString * _Nullable)body kind:(SLNoteKind)kind {
    self = [super init];
    if (self) { _identifier = [identifier copy]; _title = [title copy]; _body = [body copy]; _kind = kind; }
    return self;
}
@end
@interface SLNoteStore ()
@property(nonatomic, strong) NSArray<SLNote *> *storage;
@end
@implementation SLNoteStore
- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = @[[[SLNote alloc] initWithIdentifier:@"welcome" title:@"  Welcome  " body:nil kind:SLNoteKindPinned],
                     [[SLNote alloc] initWithIdentifier:@"draft" title:@"   " body:@"Draft locally, then review." kind:SLNoteKindPlain]];
    }
    return self;
}
- (NSArray<SLNote *> *)loadNotes { return [self.storage copy]; }
- (NSUInteger)noteCount { return self.storage.count; }
- (BOOL)renameNoteWithIdentifier:(NSString *)identifier title:(NSString *)title error:(NSError **)error {
    NSString *clean = [title stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (clean.length == 0) {
        if (error) *error = [NSError errorWithDomain:SLNoteErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"A title is required."}];
        return NO;
    }
    for (SLNote *note in self.storage) {
        if ([note.identifier isEqualToString:identifier]) { note.title = clean; return YES; }
    }
    if (error) *error = [NSError errorWithDomain:SLNoteErrorDomain code:2 userInfo:@{NSLocalizedDescriptionKey:@"Note no longer exists."}];
    return NO;
}
@end
