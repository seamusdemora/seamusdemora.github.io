## A Fancy-Ass Prompt for 'zsh' 

It seems that ***command line prompts*** are getting a lot of attention these days. I've never cared much for them...  they struck me as useless distractions for clueless dweebs to obsess over. Long story made short, a friend (*clueless dweeb himself  lol*) suggested I try one that he was using, and... surprisingly I found it functional/useful, and now I'm using it! 

#### What do I like about it?

I like that it "splits" the prompt into a `pwd` part above, and the actual (now very short) prompt below. This comes in handy when I'm *way out* in a long-*ish* path, and have a long*-ish* command. And it seems to make things easier to find when I look back through my scrollback buffer. It's got some light `git` features, but I've not used those much yet. 

I'm reluctant to **recommend** such a thing - even though I am using it myself now - but [here's the GitHub address](https://github.com/sindresorhus/pure) if you'd like to try it.  I've included the very modest customization from my `~/.zshrc` below: 

```zsh
fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure
PURE_PROMPT_SYMBOL="==>"
zstyle :prompt:pure:path color green
#  zstyle :prompt:pure:prompt color white   # looking for max contrast on black bg
zstyle ':prompt:pure:prompt:*' color 199
```

![terminal_ss](./pix/terminal_ss.png)