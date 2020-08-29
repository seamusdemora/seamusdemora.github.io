## Using command history in `zsh`

### What is the command history?

If you open a terminal - for example `Terminal.app` in macOS - and you enter a command at the prompt, that command is saved into the ***command history***. In fact, depending upon how command history is configured on your machine, every command you have ever issued could be saved into a command history. Control and maintenance of the command history is a function of the **shell** being used. Different **shells** manage the command history in different ways, though they also have much in common. If you switch between shells, your command history will be contained in different memory locations and different files.  

The ***command history*** is useful because we often use the same - or similar - commands repeatedly. These commands may contain long lists of *arguments* and *options* that are highly specific, and often arcane. Considerable time and effort may be invested in getting a particular command "tweaked" to perform a certain function in a very specific way. The utility of a command history will be obvious to anyone after using `rsync` or `ffmpeg` or `git` for a while. 

### How does one begin using `history`? 

The reader is now hopefully motivated, and asking, "How do I access my command history?" As with many things, there are many means to access the command history. Let's start with one of the simplest - `history`. The obligatory man page:

```zsh
% man history
```

unfortunately does not reveal much that is helpful. The `history` command is **built in** to the shell - as are many other commands: 

![Image for post](https://miro.medium.com/max/2586/1*zZgZoddT0QfO0zj3iPM2Ug.jpeg)



As it turns out, the [`history`](https://opensource.com/article/18/6/history-command) command is useful for **listing** the ***command history***, but not particularly helpful at **finding** the command of interest. Nevertheless, as we shall see, it does come in handy, and it's simple to use. The examples below illustrate some uses for the `history` command. Feel free to try them & return here afterward. 

Simpler still is using the *up* (<kbd>⬆︎</kbd>) and *down* (<kbd>⬇︎</kbd>) arrows on the keyboard to scroll up and down in the ***command history***. This is easily demonstrated in any active terminal window - each press of an up or down arrow button will advance or return one command further into the ***command history*** stack. Like the `history` command, this is useful, but not particularly efficient for older commands (further up in the stack) - or for those using the CLI frequently.

Let's now turn our attention to how the shell maintains the ***command history***, and by what means the user exercises control and inputs his preferences. 

As mentioned above, the ***command history*** is a function of the shell, and for purposes of this recipe the shell of interest is `zsh` - currently the default shell in macOS. The file `/etc/zshrc` contains your machine’s default settings, including a few relevant to the ***command history***. Following are those defaults as of this writing:

   ```zsh
   % less /etc/zshrc   # peruse the default settings for zsh
   ...
   # Save command history
   HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
   HISTSIZE=2000
   SAVEHIST=1000
   ...
   ```

Let's briefly review these variables:

* `HISTSIZE` declares the size of the **session history**; session as in an instance of the shell 
* `SAVEHIST` defines the size of the **history file**  
* `HISTFILE` simply declares the name of the user's history file, and where it's stored. 

Note that the ***command history*** is made up of two separate entities: the **session history** and the **history file**. They are "linked" in the following fashion: 

* when a `zsh` session is closed, the **session history** is *concatenated* to the **history file** 
* when the **session history** reaches its limit, the *overflow* is *concatenated* to the **history file** 
* when you go beyond the oldest command in the **session history**, you transition to the **history file**
* the ***command history*** of a new session, before any commands are issued, is entirely from the **history file** 
* commands in the  **session history** are unique to that session; the **history file** contains command history from (potentially) all sessions, past and present.

If you've been using `zsh` for a while, you can open your command history file at `~/.zsh_history` and see what it contains. Likewise, with this file open and in view, the operation and interaction of the **session history** and the  **history file** may be directly observed. (*You may want to temporarily reduce `HISTSIZE` and `SAVEHIST` to save time before doing so. Backing up your .zsh_history` may also be warranted.*)

Given the above, it is left as an exercise for the reader to determine the logic behind Apple's default settings for `HISTSIZE` and `SAVEHIST`. That is to say, the deep thinking that went into setting `SAVEHIST` to one-half the size of `HISTSIZE`. Extra points to the reader who shares this revelation. 

Some may be tempted to make changes to the default values of `SAVEHIST` and `HISTSIZE`. If you wish to make changes, please note:

   > **NOTE:** When changing values of `HISTSIZE` or `SAVEHIST`, **heed the instructions** in `/etc/zshrc`:
   >
   > **\# Setup user specific overrides for this in ~/.zshrc**
   >
   > **Do not make changes in `/etc/zshrc`**

With relationships between the ***command history*** *components* made clear, let us explore some additional methods for accessing the ***command history***: 

   1. *up* (<kbd>⬆︎</kbd>) and *down* (<kbd>⬇︎</kbd>) arrows on the keyboard scroll sequentially through the ***command history*** 
      2. the `history` command and its options will list selected commands
      3. <kbd>control</kbd><kbd>r</kbd> at the command prompt will search & match items in your ***command history***  
      4. `!!` runs the previous command; e.g. `sudo !!`  executes the previous command with `root` privileges

These tools, coupled with an understanding of the command history components and how they interact is quite enough to begin using the ***command history*** productively. A few examples follow with a bit more detail.

### Examples for accessing ***command history***

#### 1. <kbd>control</kbd><kbd>r</kbd>

Enter <kbd>control</kbd><kbd>r</kbd> at the command line to see the `bck-i-search:` prompt for a search term:

```zsh
% 
bck-i-search: _
```

Assume you need to find the command for an `ssh` connection; enter `ssh` as the search term:

```zsh
% ssh seamus@macbuntupro.local   # <-- a finding from command history
bck-i-search: ssh_ 
```

This is the *most recent* entry in the ***command history***. If this is NOT the host/command you're searching for, simply enter  <kbd>control</kbd><kbd>r</kbd> again to go to the next previous command. Continue <kbd>control</kbd><kbd>r</kbd> until the command/host of interest is found. When found, use the *right arrow* (<kbd>➡︎</kbd>) to select that command and end the search. This will place the selected command on the command line where it may be edited or executed (<kbd>return</kbd>). Use <kbd>control</kbd><kbd>g</kbd> to terminate the search & return to a blank command line. 

#### 2. `history` command 

Simply running the command `history` from the CLI lists the 16 most recent commands in the ***command history***. No idea why `16` is the *"magic number"* here... If you know the location of a particular command in the ***command history***, that may be specified as an argument. This is rarely useful, except perhaps to list *all* commands; i.e. `history 1` - or more likely `history 1 | less`. Perhaps slightly more useful is piping the entire `history 1` output to `grep`: 

```zsh
% history 1 | grep ssh 

# --OR--

% history 1 | grep ssh | less
```



These are only two examples. The REFERENCES below may provide more advanced methods for searching the ***command history*** more efficiently.



---

## REFERENCES:

1. [Better command history browsing in Terminal](https://www.macworld.com/article/1146015/termhistory.html) - get `history-search-forward` setup using `~/.profile` 
2. [A SO Q&A to get `history-search-forward` using `bind` in `~/.zshrc`](https://stackoverflow.com/a/51939529/5395338) 
3. [Q&A: How can I search history with text already entered at the prompt in zsh?](https://unix.stackexchange.com/questions/97843/how-can-i-search-history-with-text-already-entered-at-the-prompt-in-zsh) 
4. [Docs: zsh Line Editor's History Control](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#History-Control) ; see also [ZLE Builtins](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins) 
5. [Lorna Jane's blog on 'Navigating Bash History with Ctrl+R'](https://lornajane.net/posts/2011/navigating-bash-history-with-ctrlr) 



---



<!---  HIDDEN SHIT

Here is what I prefer instead of the defaults. Make it big… real big:

% cat .zshrc  
HISTSIZE=99999  
HISTFILESIZE=999999  
SAVEHIST=$HISTSIZE

You can edit your own `~/.zshrc` file to add in the above 3 lines.

We’re close to having history setup. But, if you run the `history` command by itself, you still only see the last 16 lines. While it is interesting what I did 5 minutes ago, I often want to see what I did 5 weeks ago. I want to see something really old in history and I will follow it with a grep. What did I do to download that repo last month?

% history | grep "git clone"

Ahh, I forgot that I need to add the `1` parameter in order to start from the beginning of history. My command changes to look as follows.

% history 1 | grep "git clone"

I don’t want to always have to type the `1`. The solution is to alias my history command. Add the following to your `~/.zshrc` file.

alias history="history 1"

Some people don’t like to alias the default behavior of a built-in shell command, so they may shorten to “`hist`” as follows. I create a new command to use called “`hist`” that will always run `history 1`. Instead of the above alias, use the following:

alias hist="history 1"

So my new command for history with a grep becomes:

% hist | grep "git clone"

You now have a shorter and more powerful command than the default “history” command. It’s quicker, easier, and more seductive.



--->