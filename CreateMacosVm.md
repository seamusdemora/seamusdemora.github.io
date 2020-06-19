# Creating macOS Virtual Machines in VMware

## An Error in Creating a macOS VM

Creating a Virtual Machine (VM) in VMware has been *dead-simple* for as long as I've used it (~9 years). That's why I was surprised recently by how **difficult** it's just become to create a VM for macOS. It would actually have been impossible without a substantial effort at work-arounds, and finally by a clever utility posted to GitHub. I posted [this question on *StackExchange*](https://apple.stackexchange.com/questions/393753/creating-high-sierra-as-vm-under-vmware-fusion) - you can see from the answers and [the discussion](https://chat.stackexchange.com/rooms/109326/discussion-between-seamus-and-user3439894) that this was not a typical VM creation.

So what happened? Why didn't it work? My host system for the VM is a 2019 Macbook Pro running macOS 10.15.5; VMware is ver 11.5.5. These are the latest versions as of this writing (June, 2020). [VMware documentation](https://docs.vmware.com/en/VMware-Fusion/11/com.vmware.fusion.using.doc/GUID-B7A0B805-BFEA-4BD3-99D8-A914897D7C36.html) states: 

>The image file is an ISO file or, for a macOS virtual machine, a .app  file. A .app file for a macOS operating system is available at the App  Store. 

The failure was [verified by another party](https://chat.stackexchange.com/transcript/message/54657972#54657972). The same party also found that under macOS 10.15.4 and VMware 11.5.3, there were no errors - macOS VM creation worked as advertised. What's happened in one revision increment to macOS and VMware? I'll leave that to others to sort out.

## Working Around the Error: A Tested Procedure to Create a macOS VM in VMware

One can spend much time trying to wangle buggy software. With a lot of help, I've found a *work-around* to the bugs in macOS 10.15.5 and/or VMware 11.5.5. Hopefully, this recipe will save others some time; or perhaps someone will share a better solution. Let's get to it:

### Why create a macOS VM?

I need a VM of macOS High Sierra as a test bed of sorts - to evaluate some options for installing Linux and other *alternative* operating systems on a [*late 2011 Macbook Pro - 17" display*](https://support.apple.com/kb/SP646?locale=en_US). This was my first Mac, and I guess I'm attached to it, but the alternative OS idea has become compelling since [Apple has announced termination of support for High Sierra](https://en.wikipedia.org/wiki/MacOS#Release_history) later this year! Of course hardware support for this Mac expired some time ago, but High Sierra being removed from support at three years old? 

At any rate, an alternative OS has now become a necessity. I made the decision to convert my 2011 Macbook to dual-boot. For now, macOS High Sierra will remain, and the other OS is TBD. Thus the need for a VM. Also, looking further ahead, a High Sierra VM might be quite useful.

### A Verified Procedure for Creating a macOS High Sierra VM

#### Prerequisites:

1. A local copy of the script: `create_macos_vm_install_dmg.sh`, available [from the author's GitHub repo](https://github.com/rtrouton/create_macos_vm_install_dmg) 

2. A copy of Apple's current High Sierra installer `Install macOS High Sierra.app` - which **may be available**<sup id="a1">[Note 1](#f1)</sup> on [Apple's website.](https://support.apple.com/en-us/HT201372) 

#### Create the VM:

##### Step 1:

With both prerequisite files located in your Desktop folder (`~/Desktop`), run the following commands in `Terminal`:

```zsh
% cd ~/Desktop
% chmod 755 create_macos_vm_install_dmg.sh
% sudo ./create_macos_vm_install_dmg.sh "./Install macOS High Sierra.app" ~/Desktop
```

The script will ask: `Do you also want an .iso disk image?`. Reply to the prompt from the keyboard with: `1` <kbd>return</kbd>. The script will post its progress to the `Terminal` window, ending successfully with this: 

```zsh
-- Building process complete.
-- Built .dmg disk image file is available at /Users/youruser/Desktop/macOS_10136_installer.dmg
-- Built .iso disk image file is available at /Users/youruser/Desktop/macOS_10136_installer.iso
```

##### Step 2:

  * Start the `VMware Fusion` app 
  * Select `File, New...` from the VMware menu bar 
  * Drag and drop the ISO file created in Step 1 into the window titled **Select the Installation Method**

From this point, the rest is bog-standard for creating a VM in VMware Fusion - consult the VMware Fusion documentation if you have any questions. The ISO file will be used to install and create a High Sierra VM on macOS Catalina. You will be prompted for location, language, etc - same as when you set up macOS on a new machine. The entire process took about 12-15 minutes on on my Macbook Pro.  

And that's it - for those who prefer a visual reference, I've attached some screenshots from the procedure in the sequel: 

#### Screenshots From the VM Creation:

##### 0. Initial Error: VMware 11.5.5 on macOS 10.15.5 w/ `Install macOS High Sierra.app`:

**Some notes:** 
  - The initial failure... 
  - VMware ver 11.5.5
  - macOS 10.15.5 (Catalina)
  - Application bundle: `Install macOS High Sierra.app`
  - This **will work** with (e.g.) macOS 10.15.4 & VMware ver 11.5.3
  - Cause of this failure presently unknown

[![VMware Fusion error][1]][1] 

##### 1. Successful High Sierra Installation

  *High Sierra VM under VMware 11.5.5 on macOS 10.15.5 using `macOS_10136_installer.iso` which was made from: `Install macOS High Sierra.app` and `create_macos_vm_install_dmg.sh`*

[![Step 1 of Successful VM Installation][2]][2]

##### 2. Successful High Sierra Installation - Choose OS

[![Step 2 of Successful VM Installation][3]][3]

##### 3. Successful High Sierra Installation - Finish Configuration

[![Step 3 of Successful VM Installation][4]][4]

##### 4. Successful High Sierra Installation - Commence VM Installation

[![Step 4 of Successful VM Installation][5]][5] 

##### 5. Successful High Sierra Installation - High Sierra Install Options

[![Step 5 of Successful VM Installation][6]][6]

##### 6. Successful High Sierra Installation - Select Installer

[![Step 6 of Successful VM Installation][7]][7]

##### 7. Successful High Sierra Installation - Begin Installation

[![Step 7 of Successful VM Installation][8]][8]

##### 8. Successful High Sierra Installation - Installation Complete

[![enter image description here][9]][9]



<b id="f1">Note 1 : </b> Apparently Apple creates **barriers** for download of their *Install* application files. I have no inside knowledge of how this works - all I can do here is share some observations. One barrier is that you  must use the `Safari` web browser when you [load this page](https://support.apple.com/en-us/HT201372) and click the link to download the *Installer* you need. The other barrier is that the macOS version you're using will determine whether or not you're allowed to actually download the file. For example, you **won't** be allowed to download the High Sierra Installer app from a macOS Catalina system!  [↩](#a1)





[1]: https://i.stack.imgur.com/MMAXL.png
[2]: https://i.stack.imgur.com/B2hmt.png
[3]: https://i.stack.imgur.com/70rgU.png
[4]: https://i.stack.imgur.com/aiwdd.png
[5]: https://i.stack.imgur.com/qhqQg.png
[6]: https://i.stack.imgur.com/MnpxL.jpg
[7]: https://i.stack.imgur.com/F9hCW.jpg
[8]: https://i.stack.imgur.com/xv6R1.jpg
[9]: https://i.stack.imgur.com/KiEav.jpg





<!---

Hidden material pending further research: 

Run these commands one at a time to make a bootable macOS High Sierra Installation media.

    hdiutil create -o /tmp/macOSHighSierra.cdr -size 5200m -layout SPUD -fs HFS+J
    hdiutil attach /tmp/macOSHighSierra.cdr.dmg -noverify -mountpoint /Volumes/install_build
    sudo Downloads/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia –volume /Volumes/install_build
    mv /tmp/macOSHighSierra.cdr.dmg ~/Desktop/InstallSystem.dmg
    hdiutil detach /Volumes/Install\ macOS\ High\ Sierra
    hdiutil convert ~/Desktop/InstallSystem.dmg -format UDTO -o ~/Desktop/macOSHighSierra.iso


ALTERNATIVE: 

https://osxdaily.com/2017/09/27/download-complete-macos-high-sierra-installer/

https://mycyberuniverse.com/macos/how-download-complete-macos-high-sierra-installer-app.html

--->