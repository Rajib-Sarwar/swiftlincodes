#import "SLLegacyPresenter.h"
#import "LegacyNotesLab-Swift.h"
NSString *SLLegacyPreview(SLNote *note) {
    return [@"Legacy preview: " stringByAppendingString:[SLNoteFormatter titleForNote:note]];
}
