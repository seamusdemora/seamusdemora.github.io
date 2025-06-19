## How to "Rip" Your DVD Collection

I decided to post this after wasting nearly a ***full day*** looking at lame, bullshit search results advertising ***malware***. I decided to post this recipe after finally discovering how to make it work. I have to say that I am disappointed and appalled at the lame collection of bullshit solutions found through Internet searches! Based on a couple of recent search experiences, I wonder if this has become ***the new normal***? Honestly - it seems that the facts are becoming more elusive, and the search engines are good for nothing except regurgitating ***AI-Generated Bullshit***!!!  

Anyway - this first solution is obviously for MacOS users, but Windows/Linux users might find some benefit also.  The "solution" has two software components: 

1.  [**`HandBrake`**](https://en.wikipedia.org/wiki/HandBrake) - the free, open-source video ***transcoder*** - available [here for MacOS](https://handbrake.fr/), or on [GitHub](https://github.com/HandBrake/HandBrake/releases). 
2.  [**`libdvdcss`**](https://en.wikipedia.org/wiki/Libdvdcss) - the free, open-source library for un-scrambling DVDs available [here in source form](https://code.videolan.org/videolan/libdvdcss), or through [MacPorts](https://www.macports.org/) (my choice), or [Homebrew](https://brew.sh/). 

### A Solution:

Obviously, you will need to install both of the software components. After doing so, you will find that `HandBrake` ***still refuses*** to decode your DVD! This is because `HandBrake` does not know where to find `libdvdcss`. Here's how to correct this ignorance: 

```zsh
% sudo mkdir -p /usr/local/lib
% sudo cp /opt/local/lib/libdvdcss.2.dylib /usr/local/lib 

# alternatively, create a symbolic link to /opt/local/lib/libdvdcss.2.dylib in /usr/local/lib 
```

Afterwards, you should find that `HandBrake` will now co-operate, and ***rip*** your DVD! 

### Some Details:

While probably of very limited interest, I'll cover some additional ***details***: 

`Handbrake` is not a user-friendly application (my opinion). [The documentation may help some - it's available here.](https://handbrake.fr/docs/en/1.9.0/) What are the alternatives to `HandBrake`? For now, all I have are *thoughts*, but they might be useful to some: 

-  FWIW, I plan on creating an alternative solution to `HandBrake` using `ffmpeg`. One question is how to decode... can `libdvdcss` do for `ffmpeg` what it does for `Handbrake`? 
-  MakeMKV... I don't know much about this software yet, but there are lots of mostly favorable comments on [Reddit](https://www.reddit.com/r/makemkv/). Unfortunately, the `MakeMKV` website is "offline" now for unknown reasons. A short-term solution is downloading it from the [archive .org website](https://web.archive.org/web/20250614003333/https://www.makemkv.com/download/). 
-  Speaking of Reddit, the [MakeMKV sub](https://www.reddit.com/r/makemkv/) is a good resource for the hardware side of DVD-ripping. After about 20 DVDs ripped, I've learned that my Apple DVD drive is "marginal" for this task! 

`libdvdcss` - like `HandBrake` - was also created by the French via the [VLC project](https://www.videolan.org/). Fortunately, [unlike some of the `HandBrake` team members](https://github.com/HandBrake/HandBrake/discussions/6717#discussioncomment-12508485), the people who run the VLC project are not afraid of the boogeymen who created the [DMCA](https://en.wikipedia.org/wiki/Digital_Millennium_Copyright_Act) and [WIPO](https://en.wikipedia.org/wiki/World_Intellectual_Property_Organization). For the record, I am all for protecting copyrights, but the boogeymen have gone way overboard...  i.e. if I buy a DVD, do I not have the right to make a copy of its contents to put on my private server to watch in my home with friends and family? I believe I do. 

You can get a copy of `libdvdcss` via [MacPorts](https://www.macports.org/install.php) as follows: 

```zsh
% port info libdvdcss
libdvdcss @1.4.3 (devel, multimedia)
Variants:             universal

Description:          libdvdcss is a simple library designed for accessing DVDs like a block device without having to bother about the decryption.
Homepage:             https://www.videolan.org/developers/libdvdcss.html

Platforms:            darwin, freebsd
License:              GPL-2+
Maintainers:          none
% sudo port install libdvdcss
...
```

Next, you'll need to find `libdvdcss`, and then copy it to `/usr/local/lib`: 

```zsh
% sudo find /opt/local -type f -iname "*libdvdcss*"    # /opt is default location for MacPort installations
...
/opt/local/lib/libdvdcss.2.dylib
...
% sudo mkdir -p /usr/local/lib
% sudo cp /opt/local/lib/libdvdcss.2.dylib /usr/local/lib 
# ALTERNATIVELY: 
% cd /usr/local/lib 
% sudo ln -s /opt/local/lib/libdvdcss.2.dylib libdvdcss.2.dylib
```

Re-start `HandBrake`, open the DVD location, and you should find that `HandBrake` now cooperates, and will ***rip*** your DVD to a file. Having the file, you can copy it to your streaming server, and watch it on your "smart" TV. ICYI, I use the [Jellyfin](https://jellyfin.org/) server hosted on my [SynologyNAS](https://www.synology.com/).  

---

