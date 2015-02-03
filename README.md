# ASImageManager
An already set up image download and cache manager to handle ASNetworkImageNode image caching and downloading on initialisation. Perfect for projects using Facebook's AsyncDisplayKit; the Image Manager utilises SDWebImage to handle both the async downloading, and image caching.

##CocoaPods

```
pod "ASImageManager"
```

#####import header

```
#import "ASImageManager.h"
```

#####Usage on a ASNetworkImageNode

```
_imageNode = [[ASNetworkImageNode alloc] initWithCache:[ASImageManager sharedImageManager] downloader:[ASImageManager sharedImageManager]];
_imageNode.URL = [NSURL URLWithString:@"http://hello-kitty.sanriotown.com/images/kitty.png"];
[self.view addSubnode:_imageNode];
```

##Improvements and Notes

You are welcome to improve ASImageManager. Since it relies on SDWebImage for image downloading, and they haven't implemented a "cancel download" method, the ability to cancel the image download doesn't exsist at present, and I'm happy for someone to come along and create a solution (it may mean creating our own async download manager using NSOperationQueue).
