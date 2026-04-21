### Some Notes Re An Upgrade From Ventura to Tahoe:

I rarely upgrade my OS. ***Why?*** I hate the way Apple robs you of your time with an upgrade; so many small, superfluous changes that take inordinate amounts of time to resolve because Apple has seen fit to embed dozens of minor, cosmetic changes and minutiae in the newer version - ***changes that they do not document!*** 

I'm posting a couple of changes that I puzzled over in my recent upgrade from Ventura to Tahoe.  Hopefully, it will help others avoid wasting their time searching for a solution.

#### 1.  Loss of the "VPN selector in the menu bar"

I use VPNs regularly. For as long as I can recall, I have used a small icon in the menu bar to select which of my configured VPNs to use; once I've selected one, a timer is displayed showing how long the VPN has been in effect. This is so much cleaner than using the "apps" supplied by th VPN service vendors. Here's what it looks like in the menu bar: 

![](/Users/jmoore/Documents/GitHub/seamusdemora.github.io/pix/VPN_menu_bar_2.png)

![](/Users/jmoore/Documents/GitHub/seamusdemora.github.io/pix/VPN_menu_bar_1.png)

![Screenshot 2026-04-21 at 12.55.24 AM](/Users/jmoore/Desktop/screenshots/Screenshot 2026-04-21 at 12.55.24 AM.png)

During the *Ventura-Tahoe* upgrade, all of my VPN configurations were retained, but I lost the "VPN selector" in the menu bar. Here's how to get it back: 

-  open `System Settings`
-  in the left-hand column, select the `Menu Bar`
-  on the right-hand side, tick the `VPN` box
-  the VPN icon should appear immediately in the menu bar

#### 2.  Keyboard shortcut <kbd>command-tab</kbd> has quit working

One of my most often-used keyboard shortcuts quit working following the *Ventura-Tahoe* upgrade... the "*selection bar*" appeared, and I could tab through the open apps, but afterwards ***nothing happened** **!?*** Here's how I got it back: 

-  open `System Settings`
-  in the left-hand column, select the `Desktop & Dock`
-  on the right-hand side scroll down to the `Mission Control` area 
-  Enable the feature: `When switching to an application, switch to a Space with open windows for the application` by sliding the toggle to the right. 

*This is one of those changes made by Apple that struck me as particularly **brain-dead**!* 