## Adding Footnotes to GFM With a *Return<sup id="a1">[1](#f1)</sup>* Feature

[Footnotes](https://en.wikipedia.org/wiki/Note_(typography)) are a long-lived and useful device in writing - especially so for technical writing. They provide a convenient means for communicating useful information to the reader without interrupting the flow of the main narrative. For example to cite a source for a direct quote, or a fact or to expand an item to provide additional information. 

However, there is this **one thing** that has always bothered me about footnotes: ***It's sometimes difficult or awkward to get back to the main narrative where the footnote reference appeared.*** This is particularly true in documents that are rendered online - or in some *electronic* format such as [*hypertext*](https://en.wikipedia.org/wiki/Hypertext). In a book, my fingers can act as an anchor to avoid losing my place in the main narrative (e.g. with *endnotes*, or in a *bibliography*). However, in an [electronic document](https://en.wikipedia.org/wiki/Electronic_document), the closest thing to *fingers* is the [back-button](https://www.techopedia.com/definition/27450/back-button) in my browser.  

But I digress... [This SE Q&A](https://stackoverflow.com/a/32119820) describes a way to to add a ***return-from-a-footnote feature*** in GitHub-Flavored Markdown (GFM). I've made this into a *recipe* in this repo because I've also found that it doesn't always work as it should, and I think I've found a way to avoid that. This [*end-around*](https://en.wikipedia.org/wiki/End-around) may not work in all cases, but knowing of it may be helpful. So - without further ado: 

##### In your mainline narrative text, create a link to the footnote using the following syntax:

```
... mainline narrative text to footnote<sup id="a1">[Note 1](#f1)</sup> 
```

You can put whatever you like inside the square brackets `[]`; I've chosen `Note 1` only because that suits me. The important thing to note here is that we're just creating a [markdown anchor](https://justin.kelly.org.au/anchor-links-in-markdown/), and using a tiny bit of html (`<sup>`) to render it as a [superscript](https://en.wikipedia.org/wiki/Subscript_and_superscript). 

##### Create the footnote using the following syntax: 

```
<b id="f1">Note 1</b> ... text of footnote here ... [↩](#a1)
```

Again note that this borrows from html. The anchor (`"f1"`) is embedded in the html bold tag (`<b>`). And at long last, the  *return-from-a-footnote feature* is revealed as a simple markdown link to the anchor created just above (`#a1`). The return icon `↩`  could be replaced with something more literate if you prefer; e.g. `go-back-to-where-you-clicked-the-footnote-link` :) 

This was all covered in [the SE Q&A](https://stackoverflow.com/a/32119820) from [@Matteo](https://stackoverflow.com/users/2928562/matteo). But when I used it in [one of my pages](https://github.com/seamusdemora/seamusdemora.github.io/blob/master/FilteringWebPagesForTheGoodStuff.md), it didn't work... specifically the  *return-from-a-footnote feature* did not work. Strictly by trial-and-error I found that if I removed the HTML tag `<hr>` from just above the footnote, it worked! And so, I replaced the HTML `<hr>` with the Markdown `---` equivalent for a horizontal line/separator - that's what allowed it to work! 

Why?... Why does this work? No idea really, but I'd have to guess that it's in the Markdown vagaries associated with supporting embedded HTML - GitHub's rendering engine in other words. And when you look at the syntax of the footnote link, and the footnote itself - you see it's a bit of a [*syntax soup*](http://xahlee.info/comp/syntax_soup_index.html) - mixing HTML and Markdown syntaxes. 

#### ... and in Conclusion

This is useful - for me at least. But I don't think it's *permanent*; it could disappear tomorrow. HTML may have reached a level of some stability, but Markdown has not. There are competing *flavors* of Markdown of course, and who knows whether they'll ever be reconciled - much less stable? Using the [Issue Reporting System](https://github.com/seamusdemora/seamusdemora.github.io/issues) you can share your experience, or improve this if you have a *better idea*. 

---

<b id="f1">1</b> ... check out the *return-from-a-footnote feature* by clicking the following icon ... [↩](#a1) 



---

#### REFERENCES: 

* [Q&A: How to add footnotes to GitHub-flavoured Markdown?](https://stackoverflow.com/questions/25579868/how-to-add-footnotes-to-github-flavoured-markdown) 