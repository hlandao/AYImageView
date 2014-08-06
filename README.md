# AYImageView
============

**Rounded async imageview downloader based on SDWebImage**

Based on [Pierre Abi-aad](http://github.com/abiaad) project [PAImageView](https://github.com/abiaad/PAImageView)

## Snapshot

![Snapshop PASwitch](https://raw.github.com/abiaad/paimageview/master/snapshot.gif)

## Usage

```objective-c
AYImageView *avatarView = [[AYImageView alloc] initWithFrame:aFrame backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
[self.view addSubview:avatarView];
// Later
[avatarView setImageURL:URL];
```

**That's all**

## Contact

[Pierre Abi-aad](http://github.com/abiaad)
[@abiaad](https://twitter.com/abiaad)

[Andrey Yastrebov](http://github.com/ayastrebov)
[@AndrewYastrebov](https://twitter.com/AndrewYastrebov)

## License

AYImageView is available under the MIT license.
