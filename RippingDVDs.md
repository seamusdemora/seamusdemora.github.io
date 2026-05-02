## How to "Rip" Your DVD Collection

I decided to post this after wasting nearly a ***full day*** looking at lame, bullshit search results advertising ***malware***. I decided to post this recipe after finally discovering one way to accomplish the objective.  Based on a couple of other recent search experiences, I wonder if this has become ***the new normal***? Honestly - it seems that the facts are becoming more elusive, and the search engines are good for nothing except regurgitating ***AI-Generated Bullshit***!!!  

Anyway - I'm posting two (2) solutions here for "ripping" DVDs: 

-  [HandBrake](https://github.com/HandBrake/HandBrake) - free, open-source video transcoder ([home page](https://handbrake.fr/)) 
-  [MakeMKV](https://www.makemkv.com/) - "perpetual beta", non-free, closed-source/proprietary

Both work on macOS, but I'll leave the final selection to the readers. Once I've gained some experience with these solutions (and perhaps others), I'll write up some analysis and recommendations, but for now - let's go. 

### Solution # 1: `Handbrake` 

This solution has two software components: 

1.  [**`HandBrake`**](https://en.wikipedia.org/wiki/HandBrake) - free, open-source video ***transcoder*** - available [here for MacOS](https://handbrake.fr/), or on [GitHub](https://github.com/HandBrake/HandBrake/releases). 
2.  [**`libdvdcss`**](https://en.wikipedia.org/wiki/Libdvdcss) - free, open-source library for un-scrambling DVDs available [here in source form](https://code.videolan.org/videolan/libdvdcss), or through [MacPorts](https://www.macports.org/) (my choice), or [Homebrew](https://brew.sh/). 

Obviously, you will need to install both of the software components. After doing so, you will find that `HandBrake` ***still refuses*** to decode your DVD! This is because `HandBrake` does not know where to find `libdvdcss`. This is corrected by moving `libdvdcss` to the location where `HandBrake` expects to find it... here's how to do that: 

```zsh
% sudo mkdir -p /usr/local/lib
% sudo cp /opt/local/lib/libdvdcss.2.dylib /usr/local/lib 

# alternatively, create a symbolic link to /opt/local/lib/libdvdcss.2.dylib in /usr/local/lib 
```

Afterwards, you should find that `HandBrake` will now co-operate, and ***decode*** your DVD! It worked for me... I was able to re-encode several DVDs (no BluRays), and all were view-able on my TV. 

`Handbrake` is not the most user-friendly application (my opinion). [The documentation should help - it's available here.](https://handbrake.fr/docs/en/1.9.0/) There is also a [discussion group on reddit devoted to `Handbrake`](https://www.reddit.com/r/handbrake/). Their [GitHub repository](https://github.com/HandBrake/HandBrake) also provides areas for [Issues/bug reports](https://github.com/HandBrake/HandBrake/issues), and for [Discussions/Q&A](https://github.com/HandBrake/HandBrake/discussions).

A few initial thoughts/impressions re `Handbrake`: 

-  HandBrake's development team makes it clear that their focus is *"transcoding"*; i.e. they specifically exclude the ability to make *copies* of DVDs using the standard MPEG2 coding used on the majority of DVDs.  This struck me as an odd stance, but perhaps I'm *missing something*? Potential users should be aware that due its exclusive focus on *transcoding*, there will inevitably be [**"Generation Loss"**](https://en.wikipedia.org/wiki/Generation_loss) in the video files it produces. Therefore, minimizing this generation loss is a particular challenge for `HandBrake` users.
-  Many of the detailed settings & options in `HandBrake` confused me; especially wrt the various encoding schemes available. My objective for DVD ripping is primarily one of ***preservation*** of my DVD/BRD library/collection. As such, not providing users the ability to retain the existing encoding (whatever that may be) caused me to worry about [*generation loss*](https://en.wikipedia.org/wiki/Generation_loss)! 
-  I wondered if `ffmpeg` might not be a substitute for `HandBrake`? FWIW, I plan on investigating an alternative solution to `HandBrake` using `ffmpeg`. One open question is how to work around the copy protection in `ffmpeg`... iow, can `libdvdcss` do for `ffmpeg` what it does for `Handbrake`? 

***In summary*** then, `Handbrake` was able to re-encode several of my DVDs into *mp4* and *mkv* *containers (files)*.  Afterwards, I was able to move these files to my SynologyNAS, and use the [`Jellyfin` server](https://jellyfin.org/) I installed there to serve these files to my TV. Of course you need not own any Synology hardware to use `Jellyfin`... you can [install `Jellyfin` on a Raspberry Pi](https://duckduckgo.com/?t=ffab&q=jellyfin+server+on+raspberry+pi&ia=web)! 

### Solution # 2: `MakeMKV`

-  MakeMKV is an "odd case"... it's so odd that it's difficult to describe in detail. Based on a "whois" lookup, the makemkv website is operated by a person or persons in Russia. It's said to be "free" during beta (it's been in beta since its original release over 10 years ago), but a License Fee ($60+) is required to use it beyond approximately 30 days. Also, there is no license agreement, so you don't really know what you are getting for your money. There is [very little documentation](https://www.makemkv.com/onlinehelp/), and support is via the [MakeMKV User Forum](https://forum.makemkv.com/forum/). Fortunately, MakeMKV becomes rather straightforward in routine operation after a very short time.
-  Despite its many "oddities", after using the MakeMKV software for a while I am impressed with its reliability. After ripping a number discs from my collection, it ***has never failed*** to successfully copy and decode a DVD or a BluRay disc that was playable on my DVD player. There are many, mostly favorable, comments on [Reddit](https://www.reddit.com/r/makemkv/). However, know that one or more high-quality optical disc readers are required for reliable ripping.
-  Unfortunately, the reliability of the `MakeMKV` website does not match the software!  It occasionally goes "offline" for unknown reasons, and for indeterminate times. A short-term solution is *said to be* downloading MakeMKV from the [archive .org website](https://web.archive.org/web/20250614003333/https://www.makemkv.com/download/) - but I've not tried that. The "temporary beta keys" are posted on an irregular basis - meaning that it's impossible to use the software without having a paid "permanent license". 

In summary, MakeMKV is a solid performer, and it has the advantage of saving the original audio and video - as recorded on the DVD/BluRay - to its output file. Again, this means that, unlike HandBrake, MakeMKV does not force the audio and video data to be re-encoded, thereby creating generation loss.  

### In Closing: 

I am going to avoid (at least for now) a discussion or "How-To" on adding the "decoder libraries" to `HandBrake`. These decoder libraries are included in the MakeMKV software package that you download - **but not with HandBrake**. If you want to try `HandBrake`, know that the DVD "decoder library" is called `libdvdcss`, and the one for BluRays is called `libaacs.dll` (a `keydb.cfg` file is also required with `libaacs`); both are usually available from the same source. The information on where to find, and how to install these libraries is available to everyone for the cost of an Internet search. 

<!---

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

--->

---

