# Iota

Emacs configuration with some nice user friendly defaults

## Installation
To install simply download `init.el` into your `~/.emacs.d` directory.

```
mkdir ~/.emacs.d
wget -O ~/.emacs.d/init.el https://github.com/mitch-kyle/iota/blob/master/init.el
```
## Usage / Some Emacs Basics
### Understanding Keybindings
In Emacs keys are bound to chords which are different key combination after one another.
a key combination can be qualified with one of three modifiers: `s` for super (or the windows key),
`C` for control, and `M` for alt.

E.g.: `C-x C-b` would be Control+x followed by Control+b or
      `s-j k` would be Super+j followed by k without any modifier

### Basic Keybindings
This configuration will set some default keybindings, feel free to change them to suit your needs

| Key Chord | Function | Description |
|---|---|---|
| `C-g` | `keyboard-quit` | Cancel the current interactive command |
| `M-x` | `smex` | Interactively call a function by name|
| `C-x C-f` | `ido-find-file` | Open a file for editing |
| `C-x C-s` | `save-buffer` | Save the current file |
| `C-s` | `isearch-forward` | Search for text in a buffer |
| `C-x b` | `ido-switch-buffer` | Change to another buffer |
| `C-x C-b` | `ibuffer` | List buffers |
| `C-x 2` | `split-window-below` | Split the window horizontally |
| `C-x 3` | `split-window-right` | Split the window vertically |
| `C-x 1` | `delete-other-windows` | Remove all window splits except one currently focused |
| `C-x 0` | `delete-window` | Remove the current window split |
| `M-<left>` | `windmove-left` | Move to the window to the left |
| `M-<right>` | `windmove-right` | Move to the window to the right |
| `M-<down>` | `windmove-down` | Move to the window below |
| `M-<up>` | `windmove-up` | Move to the window above |
| `C-x o` | `other-window` | Cycle to the next window |

#### Clojure/Cider
Keys available in clojure and cider modes:

More information is available here: [Using Cider](https://docs.cider.mx/cider/usage/cider_mode.html)

| Key Chord | Function | Description |
|---|---|---|
| `C-c M-j` | `cider-jack-in` | Start a repl for the current project |
| `C-c C-z` | `cider-switch-to-repl-buffer` | Switch between file and repl |
| `C-c C-e` | `cider-eval-last-sexp` | Evaluate the sexp under the cursor |
| `C-c C-k` | `cider-load-buffer` | Load the current buffer into the repl |
| `M-.` | `cider-find-var` | Lookup a variable definition |
| `C-c M-n M-n` | `cider-repl-set-ns` | Set the repl namespace to the current file |
| `C-c C-t t`| `cider-test-run-test` | Run the test under the cursor |


## Configuration
