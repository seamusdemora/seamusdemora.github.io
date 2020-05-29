## MacPorts: My Experience

This began several months ago after realizing that the [one-time largest corporation in the world](https://en.wikipedia.org/wiki/Apple_Inc.) was shipping [16-year-old open source software](https://opensource.apple.com/source/bash/bash-118.40.2/) with their *pricey* computers. For any [**Apple Apologists**](https://forums.macrumors.com/threads/apologists.2093606/) reading this, please just STFU, and move on. To say I'm disappointed with Apple would be an understatement. As I see things today, we must choose our technology products to balance our exposure to exploitative and extortionate corporate interests against the very personal concept of *value*.  

In other words, I still count myself as a mac user at this point, but [I won't allow Apple to dictate my computing environment](https://duckduckgo.com/?q=fuck+you+Apple&t=ffnt&ia=web)! As I occasionally use my mac for more than perusing social media, it's important to me to have reasonably up-to-date tools, and the ability to add tools to suit my needs. As Apple has no package manager, one is required to find a third party. Fortunately there are (at least) two: [MacPorts](https://www.macports.org/), and [HomeBrew](https://brew.sh/). After [some research](https://duckduckgo.com/?q=Homebrew+vs+Macports&t=ffnt&ia=web), I decided that [MacPorts](https://www.macports.org/) was a better alternative. My experience to date suggests I made a good decision.

That said, the sequel below is simply my attempt to help others gain a bit of freedom-of-choice, and share what I learned during and after the MacPorts install. As of today, I've installed MacPorts on a new-ish (2019 Catalina - 10.15.4), and an old-ish (2011 High Sierra - 10.13.6) Macbook Pro. Most of this post is based on the 2019 Catalina installation, but I've added a [section at the end noting the difference between the Catalina and High Sierra installations](#notes-on-the-high-sierra-Installation-of-macports). I should also say that much of what follows is borrowed from [MacPorts Install page](https://www.macports.org/install.php). Much more [detailed guidance may be found on the MacPorts' website](https://guide.macports.org/). Finally, I am not affiliated with MacPorts in any way.

### Installation: 

I'm not going to attempt a summary of the installation procedures. Installation of MacPorts is a bit more complicated than other package managers you may have used. This additional complexity is simply a fact of life - the inevitable result of being an *open-source* package manager for a *closed-source* operating system. And Apple does not make this easy - they can be arbitrary and capricious, and their decisions are based on serving their own interests *first* - perhaps *exclusively* in some cases. 

The MacPorts installation procedures all follow a similar *pattern*, but each version of macOS has a different download, different `Xcode` dependencies, different `command line developer tools` dependencies, and may even have different procedures. The [only reliable and up-to-date guides to installing MacPorts on macOS is on their website.](https://guide.macports.org/#installing) Use it.

### Post Installation:

MacPorts "pkg" installer worked well for me, and there's nothing I can add. The MacPorts installer updates the $PATH env variable for you, but you will need to *source it* before it takes effect:

```zsh
$ . ~/.profile						# use for bash; aka `source ~/.profile` 
% . ~/.zprofile						# use for zsh; aka `source ~/.zprofile`
```

### Fundamental Usage of MacPorts:

NOTE: This document covers only the basics. It is intended only as a brief summary of what I consider the most frequently used commands in MacPorts. See [MacPorts excellent documentation](https://guide.macports.org/) and/or `man port` to get the details on using this tool. 

The primary user interface to MacPorts is the ***`port`*** command, and the various facilities it provides for installing ports. *Learn the details by reading the man page; from the CLI enter: **`man port`*** The first thing you should do after you install MacPorts is to make sure it is fully up to date by pulling the latest revisions to the Portfiles and any updated MacPorts base code from their rsync server, all accomplished simply by running the ***`port selfupdate`*** command as the `superuser` on your system:

#### Update your ports:

```zsh
% man port							# read the port man page
% sudo port selfupdate	# update/sync your local system with the MacPorts server
# the output may also include a suggestion to run `port upgrade outdated`
% sudo port upgrade outdated
# ...
%
```

#### Use `cron` to automate updates and keep a log:

Running this `port selfupdate` command on a regular basis is [recommended](https://guide.macports.org/#using.port.selfupdate) -- it ensures your MacPorts installation is always up to date. One way to accomplish this is to set up a `cron` job as follows: 

```zsh
% sudo crontab -e					# use root's crontab as sudo is required
```

This will launch the editor specified in your environment. Enter the following lines in the editor and then save it: 

```
0 2 */2 * *  (echo "----------\n"$(date) && sudo /opt/local/bin/port -q selfupdate) >> /Users/<username>/portupdatelog.txt 2>&1
15 2 */2 * * (sudo /opt/local/bin/port -q upgrade outdated && echo "----------\n") >> /Users/<username>/portupdatelog.txt 2>&1
```

This will run `port selfupdate` command **and** `port upgrade outdated` every other day at 2 AM. It will also create an entry in a logfile that captures `stdout` and `stderr` outputs. You may refer to the [crontab guru](https://crontab.guru/) if you need help changing the schedule for this cron job.

#### Clean up after yourself:

Another maintenance item is cleaning up inactive or deprecated ports to reclaim disk space:

```zsh
% sudo port reclaim
# ...
%
```

#### Finding and installing ports:

Afterwards, you may search for ports to install:

	port search <portname>

where <portname> is the name of the port you are searching for, or a partial name. To install a port you've chosen, you need to run the port install command as the Unix superuser:

	sudo port install <portname> 

where now `<portname>` maps to an exact port name in the ports tree, such as those returned by the port search command. Please consult the port(1) man page for complete documentation for this command and the software installation process. 

#### What ports are installed?: 

This is a *two-part* question. Some ports are installed because we **requested** they be installed; other ports are installed because they are needed by ports we requested.

```
% port installed requested    # su privileges are not needed
# ...
% port installed              # includes dependencies for requested ports
# ...
```

#### Uninstall an installed port:

You will occasionally want to *un-install* or remove ports you have previously installed: 

```zsh
% sudo port uninstall <portname>
```

#### Using `sudo` as an un-privileged user:

One other item may be useful ***if you run your mac as an unprivileged user*** - grant your username `sudo` privileges necessary to maintain certain elements of the MacPorts installation. Here's one way to do it:

```zsh
% sudo visudo
# add the following to your sudoer file:
<username> ALL = (ALL) /opt/local/bin/*
```

### Documentation & Support:

Help on a wide variety of topics is also available in the project [Guide](https://guide.macports.org/) and through the [Trac portal](https://trac.macports.org/) should you run into any problems installing and/or using MacPorts. Of particular relevance are the [installation](https://guide.macports.org/#installing) & [usage](https://guide.macports.org/#using) sections of the former and the [FAQ](https://trac.macports.org/wiki/FAQ) section of the [Wiki](https://trac.macports.org/wiki), where MacPorts keeps track of questions frequently fielded on their [mailing lists](contact.php#Lists).

If any of these resources do not answer your questions or if you need any kind of extended support, [reach out and make contact](https://www.macports.org/contact.php)! 

### Notes on the High Sierra Installation of MacPorts

There are different installers for each version of macOS; they are [listed on the MacPorts install page](https://www.macports.org/install.php). In general, the installation experience on *High Sierra* was the same as for *Catalina*. The difficulty came about in having to upgrade an older version of *Xcode* on my High Sierra system. Since Apple does not provide an in-app upgrade mechanism for Xcode, I felt the safe approach was to un-install the old *Xcode*. If you know what to do, un-installing Xcode is only tedious; if you don't know what to do, it could lead to disaster. I didn't (and still don't) know how to un-install Xcode because Apple doesn't provide that information. I didn't let ignorance stop me however; [I un-installed by this procedure](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/MacStuff.md#23-upgrade-xcode-on-high-sierra-or-why-does-apple-crap-on-us). All I can say at this point is: "*so far, so good*".



### REFERENCES:

* [Installing MacPorts on MacOS 10.15 Catalina](https://www.ghostwheel.com/2019/09/05/installing-macports-on-macos-10-15-catalina-beta-7/) - Some notes from Chris Knight on his installation.

