## Uses for `sudo` in macos:

If you've ever used a Linux or Unix system, you've probably used `sudo` for administrative tasks that require elevated privileges. However, `sudo` is also available for macos. `sudo` is designed to implement *fine-grained* security policies. As an [example of *fine-grained*](https://superuser.com/questions/167631/fine-grained-sudoers-configuration-allowed-commandline-arguments), `sudo` can be configured to allow a user to run a particular command, but exclude certain options for the command. [Don't get `sudo` confused with `su`](https://kb.iu.edu/d/amyi).

And so, when you say, ***"sudo access would mean the highest access on the machine so everything will be accessible"***, that's simply ***not true***. IMHO, `sudo` was made to order for this situation: "You've loaned (or share) your mac with someone, and wonder, "How do I give a user access to resources he needs to do his job, *without* giving him the run of the castle?" You may also appreciate the fact that `sudo` performs extensive *logging* of all `sudo` usage. This provides *accountability* for all `sudo` users because, unlike `su`, users execute `sudo` from *their* account, not the `root` account. I learned that there are quite a few seemingly-knowledgeable users of mac OS that are [stubbornly mis-informed](https://apple.stackexchange.com/a/360200/149366) about `sudo` - you needn't be one of them. 

Here are two examples to illustrate the value of `sudo`; two entries for the `sudoers` file - the file that defines a user's privileges under `sudo`. In the first example, the user `friend` will be given "access to everything"; i.e. unlimited `root` privileges: 

### Example: `sudo` for Full `root` Privileges

```
friend   ALL = (ALL) ALL  
```

In the next example, the user `friend` will only be given privileges to run the software update option (`-U`) on the utility [`youtube-dl`](https://ytdl-org.github.io/youtube-dl/index.html). This specification will confer `root` privileges to run **only** this one command with this one option (although in this case most of the other options do not require `root` privileges.): 

### Example: `sudo` for Limited `root` Privileges

```
friend   ALL = (ALL) /usr/local/bin/youtube-dl -U
```

## A Brief Overview of `sudo`: 

I can't explain `sudo` in detail. As you'll see that simply is not possible. Instead, I'll try to provide provide a "*walking tour*" with some references that will give you a better understanding of what `sudo` can (and can't) do, and how to **configure** `sudo` to implement the security policy you want. 

- [Todd Miller](https://www.sudo.ws/todd/todd.html) currently maintains `sudo` as he has [since 1994](https://en.wikipedia.org/wiki/Sudo#History). That probably makes him the ***godfather of `sudo`***.  

- There is a [prodigious amount of documentation on `sudo`](https://www.sudo.ws/), including many older versions - including [ver. 1.9.13](https://www.sudo.ws/man.html) used in the current version of macos (Ventura). 

- Perhaps a good place to begin learning about `sudo` is [in a nutshell](https://www.sudo.ws/intro.html) 

- Having read this nutshell overview, you now know that `sudo` is *typically* configured using the `sudoers` file. This is where you will create the specifications that implement your security policy; the specifications that define what resources your friend can access while using your machine. 

- Again, there's a lot of documentation. You'll want to read `man sudo` ([online](https://www.sudo.ws/docs/man/1.9.13/sudo.man/)), and `man sudoers` ([online](https://www.sudo.ws/docs/man/1.9.13/sudo.man/)). **OK, skim through it at least, and study the EXAMPLES** :) And BTW, your friend will need to read `man sudo` also, as he'll be using it! 

- Once you've decided what resources your friend needs, you can prepare to tackle actually editing/creating your own `sudoers` file. But there are some things you should know first:  

1. The `sudoers` file should only be edited with `visudo`. To access it, you'll need to be logged in as (or `su` to) the "admin" user on your Mac. Upon entering the command shown below, the **Sample** sudoers file will be opened in your admin user's default editor (I've set mine to `nano`). 

2. Know that editing the `sudoers` file carries risks. Minimze those risks by **NEVER** editing `sudoers` except through the `visudo` app. `visudo` is designed to validate the syntax of the `sudoers` file when it is saved. That won't save you from errors that have the correct syntax of course, but it's far less likely that you'll leave your machine in an unusable state! 

## Making changes to the `sudoers` file:

**And so:** To edit the `sudoers` file, login as (or `su` to) the admin user, open a terminal window, and enter: 
```bash
% sudo visudo
Password:                # you'll need to enter your admin user's password here
```

The editor specified in your `environment` will open, and the `sudoers` file will be listed. The `User specifications` section is near the end of the file; you can insert one of the example lines from above, taking care not to edit either of the existing lines: 

> root            ALL = (ALL) ALL  
> %admin          ALL = (ALL) ALL  
> \# insert your additions below here; 
>
> \# e.g. to allow `friend` to only update youtube-dl (via `youtube-dl -U`), add this line:
>
> friend   ALL = (ALL) /usr/local/bin/youtube-dl -U  

When you finish your edits, write the modified file, then exit the editor. `visudo` will automatically check the syntax of your `sudoers` file, and alert you if it finds a problem. You should never override these alerts; find and fix the issue, or simply comment out your changes until you do. 

## Using `sudoedit` to limit access to files 

**One final example:** You wanted to grant `sudo` access, but not allow access to any data stored for your user. For purposes of this example I'll assume that you want to give your friend the ability to edit the file `/etc/fstab.hd` (a *do-nothing* file), and *all* files in the directory `/etc/ssh`.

You can use the `sudoedit` specification in the `sudoers` file to grant your friend access to files or entire directories that you specify. Here's how to accomplish that: 

1. Run `sudo visudo` to open the `sudoers` file for editing. 

2. As previously, enter the following `sudoedit` lines just below those you added previously; i.e. 

> root            ALL = (ALL) ALL  
> %admin          ALL = (ALL) ALL  
> \# insert your additions below here; e.g.:  
> friend   ALL = (ALL) /usr/local/bin/youtube-dl -U  
> \# insert sudoedit specs below here:  
> friend          ALL = (root) sudoedit /etc/ssh/*  
> friend          ALL = (root) sudoedit /etc/fstab.hd   

To edit these files, your friend will enter the following command(s) in a terminal window: 

```bash 
% sudo -e /etc/fstab.hd  

# or...

% sudo -e /etc/ssh/ssh_config

# which will open the specified file in `friend's` specified editor
```
## Limits of `sudo`

You should also keep in mind that `sudo` has its limits. 

First and foremost, `sudo` is used to get  `root` privileges for a user from the command line (Terminal). It has no role in determining privileges anywhere else in the system; e.g. to add a new user in `System Preferences`. Outside the shell then, the *authorization database* controls access privileges, and `sudo` has no relevance. 

Secondly, `sudo` *should NOT be considered as a tool to harden the system against malicious users*. Rather, it's simply a tool for reducing risk and increasing accountability for *authorized* users. That's not to say it "rolls over", it's only to say that its purpose is not system hardening. 

## The sequel

As this was intended only as an introduction, this seems like a good point to stop. If you decide to try `sudo`, and you encounter difficulty, there are at least two StackExchange Q&A sites that may prove helpful: [SuperUser SE](https://superuser.com/) and [Unix&Linux SE](https://unix.stackexchange.com/) are two examples. In fact, this post was originally an Answer to a Question on the [Ask Different SE](https://apple.stackexchange.com/) site. Some of the comments to [that answer](https://apple.stackexchange.com/a/360272/149366) are *interesting*... 

---------------------
### Other References for `sudo`: 

1. [AppleGazette on editing the `sudoers` file](https://www.applegazette.com/mac/pro-terminal-commands-how-and-why-to-edit-sudoers-on-macos/)   
2. [AP Lawrence on *Using `sudo`*](https://aplawrence.com/Basics/sudo.html)  
3. [Using `sudoedit` to limit file editing to a specific directory/ies](https://serverfault.com/a/206836/515728)  
4. [More on `sudoedit` (aka `sudo -e`, aka `sudo --edit`)](https://stackoverflow.com/a/22084506/5395338)  
5. [What's So Great About `sudoedit`?](http://www.wingtiplabs.com/blog/posts/2013/03/13/sudoedit/)  
6. [Good general (not Mac-specific) help from from Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file-on-ubuntu-and-centos)  
7. [The `sudo` command, Part 2 of a 4-part series on "*Demystifying root*"](https://scriptingosx.com/2018/04/demystifying-root-on-macos-part-2-the-sudo-command/) 
8. [FYI, Feb 4, 2020: `sudo` security flaw patched - make sure your system is updated](https://arstechnica.com/information-technology/2020/02/serious-flaw-that-lurked-in-sudo-for-9-years-finally-gets-a-patch/) 
9. [Q&A: How to set visudo to use a different editor than the default on Fedora?](https://unix.stackexchange.com/questions/4408/how-to-set-visudo-to-use-a-different-editor-than-the-default-on-fedora) 

