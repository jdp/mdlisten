# mdlisten

`mdlisten(1)` is a command-line utility to issue long-running [Spotlight queries][spotlight-queries] from the command line.
It’s like [`mdfind(1)`][mdfind] with the `-live` option except that it outputs the absolute path of new results instead of aggregating them into a useless count.

### Install

Run `make` to build the `mdlisten` executable and then put it in your [`PATH`][path-var].

### Usage

```
mdlisten <query>
```

### Example

Upload screenshots to your web host as you take them.

``` bash
mdlisten kMDItemIsScreenCapture = 1 | while read -r filename; do
    scp "$filename" you@domain.com:/var/www/domain.com/screenshots
done
```

[mdfind]: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/mdfind.1.html
[path-var]: https://en.wikipedia.org/wiki/PATH_(variable)
[spotlight-queries]: http://osxnotes.net/spotlight.html
