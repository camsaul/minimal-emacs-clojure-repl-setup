Barebones Emacs setup for using [CIDER](https://github.com/clojure-emacs/cider) REPL.

#### Install Emacs

```shell
brew install emacs --with-cocoa
```

#### Put this in your `~/.emacs.d` directory:

```shell
git clone https://github.com/camsaul/minimal-emacs-clojure-repl-setup.git ~/.emacs.d
```

#### Launch the CIDER REPL:

```shell
cd my-clojure-project
emacs -cider &
```

That's it!