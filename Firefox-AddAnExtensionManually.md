## Firefox - adding an extension manually

This is something I'm ***not*** familiar with at all, but I stumbled into a solution, and wanted to post it here so I don't forget it. Here's the problem: 

| `One of my favorite Firefox extensions - "KellyC Image Downloader" - recently disappeared from the menu of extensions. "Poking around" led me to the GitHub site for the missing extension, where I read the authors had removed the extension because they felt there was insufficient interest to warrant their continued efforts.` |
| :----------------------------------------------------------- |

Fortunately, the authors of the [`KellyC Image Downloader` have left their code on GitHub](https://github.com/NC22/KellyC-Image-Downloader) after they decided to discontinue development... unfortunately, they left no instructions for how to install their extension into Firefox. I pieced this procedure together from several sources, and was pleasantly surprised that it actually works. 

uh... before I detail the procedure, I should detail a *drawback*: Manually loading an extension into Firefox requires that it be re-loaded each time Firefox is re-started. IOW, to retain usage of the extension, you'll need to repeat ( *at least part of* ) the procedure below any time Firefox is "Quit". Maybe there's a clever way to avoid this, but I've not found it. 

#### Manual install procedure for `KellyC Image Downloader` extension:

1. Download the [extension1293_manifest_v3.zip](https://github.com/NC22/KellyC-Image-Downloader/releases/download/1.2.9.3/extension1293_manifest_v3.zip) file from the ["Releases" page on the GitHub site.](https://github.com/NC22/KellyC-Image-Downloader/releases)  

2. Unzip the .zip file to a folder (easily done from `Finder`) 

3. In the unzip'd folder, locate the file named `manifest.json`, and open it in your text editor. 

4. ```
   # make one change in the file: 
   # FROM: 
      "background": {
           "service_worker": "background.js"
      },
   
   # TO: 
      "background": {
           "scripts": ["background.js"]
      },
   ```

5. Save the file, exit the editor.

6. ```
   # in the Firefox "address bar", enter the following destination: 
   
   about:debugging#/runtime/this-firefox 
   
   # you should see a page with Mozilla Firefox in the headline, and just below that, a heading titled: "Temporary Extensions":
   
   click the button labeled "Load Temporary Add-On..." 
   
   # a Finder window/tab will open; use Finder to navigate to the manifest.json file modified in Step 4 above: 
   
   select the modified "manifest.json" file, and then click "Open" in Finder
   
   # the "KellyC Image Downloader" extension should now appear in the list of "Teporary Extensions"! If it does, pat yourself on the back for a job well done. 
   ```

6. And that's that - until you `Quit` Firefox. Upon re-starting Firefox, you will find that the  `KellyC Image Downloader` extension - a ***temporary*** extension - has disappeared. When that happens, perform Step 6 above to restore it. 

#### For the future: 

Hopefully, the authors of this extension will re-think their decision to discontinue development, or perhaps another clever developer will "fork" the GitHub repo, and re-introduce it into the Firefox extensions menu. Until then, we have this bodge to see us through. 