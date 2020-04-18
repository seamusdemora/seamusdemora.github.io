## Filtering Web Pages to Get the Good Stuff

### Background & Motivation

I began this *recipe* with the idea that I could cobble a couple of utilities together that would avoid the dreadful shit that too many [media outlets](https://en.wiktionary.org/wiki/media_outlet) dump into their online "news articles". The idea began when I clicked a link in a [Tweet](https://www.merriam-webster.com/dictionary/tweet), which loaded a page from [The Telegraph](https://www.telegraph.co.uk/) in my browser, and then one from [The Daily Mail Online](https://www.dailymail.co.uk/). I was repulsed by the volume of junk, inappropriate advertisements, and demands for "registration" to actually see the article. And I couldn't even see the article because it was covered with an "overlay" that demanded I register before being allowed to view the content of the article. 

### My Search for Relief

I copied the URL of one of these blocked stories, and fed it into the [**`curl`**](https://www.lifewire.com/curl-definition-2184508) utility on my macbook. `curl`, or **cURL** is an [open-source software program](https://github.com/curl/curl) that is invoked from the [command line](https://en.wikipedia.org/wiki/Command-line_interface). Entering the command and a URL will cause that URL (a webpage in this case) to be downloaded to your computer. It has an option to download the webpage into a file so that you can load and read it in a web browser (Firefox, Chrome, Explorer, Safari, etc, etc). I reckoned this *might* get around the *block*, and it did! I've learned since then that it doesn't work on all media websites - but enough to make it worth a few seconds of effort. In case you want to try it: 

```bash
curl -o ~/CurldWebPage.html http://www.someplace.com/SomeContent.html
```

The `-o` option specifies the output file that `curl` will use to save the content it downloads at the specified URL. 

To lose all the ads and useless junk in the page I thought thatI could [`pipe`](https://en.wikipedia.org/wiki/Pipeline_(Unix)) the `curl` output through an HTML filter (perhaps [`Beautiful Soup`](https://www.crummy.com/software/BeautifulSoup/)) to get the content I wanted without all the annoying, revenue-generating<sup id="a1">[Note1](#f1)</sup> shit the publishers load into their pages. 

### A Discovery

And finally, to the point of this recipe: I learned it's not necessary to create a DIY project for this because there are some excellent, free and open-sourced tools that are already doing this. I use Firefox as my primary browser (because it seems to have a higher level of *default* privacy protection). I discovered an *Add-on Extension* for Firefox called [Tranquility Reader](https://tranquility.ushnisha.com/) that does a wonderful job at *shit-filtering*. For Chrome, there is a similar free and open-sourced *Extension* called [Just Read](https://github.com/ZachSaucier/Just-Read) that also does a very good job. 

And so, if you're like me, weary of the constant stream of crap the media outlets would hose you with, you should know that considerable relief is available with almost no effort on your part. [Tranquility Reader](https://tranquility.ushnisha.com/) for Firefox, and  [Just Read](https://github.com/ZachSaucier/Just-Read) for Chrome. 



<b id="f1">Note1:</b> Contrary to the impression one might get from reading this, I have nothing at all against businesses who seek to generate revenue. It is after all, the sole motivation of most for-profit business formation, and the backbone of a healthy free-market economy. But note that ***we have not contracted with these swine to hoover up our personal data, deposit 'tracking cookies' on the computers we own and sell the data they collect on us to any third party who will pay the price.*** Consequently I have no compunction about avoiding their *shitty tricks* with some of my own! [↩](#a1) [goback](#a1)  

<hr>

### REFERENCES: 

1. [A Q&A at ResearchGate on extracting useful content from websites](https://www.researchgate.net/post/How_do_I_extract_the_content_from_dynamic_web_pages) 
2. [Some Firefox "add ons" for improving readability](https://addons.mozilla.org/en-US/firefox/search/?platform=mac&q=readability&sort=relevance&type=extension) 
3. [I've just installed the "Tranquility" add on in Firefox, and it seems to work well](https://addons.mozilla.org/en-US/firefox/addon/tranquility-1/?src=search) 
4. [A script or source code would support a customized solution (e.g. `curl someURL | readability-script`), and apparently source code may be extracted from add ons!)](https://www.instructables.com/id/Extract-Firefox-Addon-Source-Code/) 
5. Other "filters" such as [`Readability`](https://www.ghacks.net/2010/03/09/readability-firefox-add-on/), and [Boilerpipe](https://github.com/kohlschutter/boilerpipe) may be deprecated?? 
6. [Search for libraries or utilities for html scraping on linux](https://duckduckgo.com/?q=library+utility+html+scraoing+linux&t=ffnt&ia=web) 
7. [Some webscraping tools...](https://linuxhint.com/top_20_webscraping_tools/) 
8. [SE Q&A that is a "must-read" as the author of `boilerpipe` provides an answer on *What is readability?*](https://stackoverflow.com/questions/3652657/what-algorithm-does-readability-use-for-extracting-text-from-urls/4240037#4240037) Note: Recommend you read ***all*** of the answers. 
9. [A brief overview of tools for extracting text from HTML pages](https://www.bigdatanews.datasciencecentral.com/profiles/blogs/how-to-extract-text-from-html-document-these-tools-we-can-use) 
10. I'm now using the [`Tranquility Reader`](https://tranquility.ushnisha.com/) as an *extension* (or *add-on*) in Firefox. I like what it does on "dirty" web pages... mostly news & weather outlets! 
11. I'm using the [`Just Read`](https://github.com/ZachSaucier/Just-Read) *extension* in Chrome. 

