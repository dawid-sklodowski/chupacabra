chupacabra
==========

[![Gem Version](https://badge.fury.io/rb/chupacabra.png)](http://badge.fury.io/rb/chupacabra)
[![Build Status](https://travis-ci.org/dawid-sklodowski/chupacabra.png)](https://travis-ci.org/dawid-sklodowski/chupacabra)
[![Code Climate](https://codeclimate.com/github/dawid-sklodowski/chupacabra.png)](https://codeclimate.com/github/dawid-sklodowski/chupacabra)
[![Coverage Status](https://coveralls.io/repos/dawid-sklodowski/chupacabra/badge.png)](https://coveralls.io/r/dawid-sklodowski/chupacabra)

A personal, encrypted password keychain.

Chupacabra is a password generation, storage, and retrieval mechanism, easily accessible via a system-wide keyboard shortcut.  It reads URL from your active browser and puts your password for given domain into clipboard. If password doesn't exist yet, it will generate random 32 characters password which looks like this: ```pY9)YjiU^cEqzrhz#i(@qt4zu(!NT3No```

Currently it works with MacOS X only.


### Installation

Run in your terminal console

    # Install gem
    $ sudo /usr/bin/gem install chupacabra
    
    # Hook chupacabra into MacOs
    $ chupacabra --install

Create Keyboard Shortcut (cmd-K works with Safari and Chrome):

    System Preferences -> Keyboard -> Keyboard Shortcuts -> Services -> Chupacabra

### Usage

While being on a website or in any application, pressing the assigned shortcut causes `chupacabra` to fetch your password from encrypted storage (or generate a new one) and pastes it for you (into the field you have focused in).

When running for the first time (since boot), it will ask you for your chupacabra global password. The global password stays in memory until you restart your computer.

### How it works

When you press the chupacabra keyboard shortcut, the relevant password is fetched from encrypted storage—or a new one is generated.

For web browsers, you will have one password stored per domain. For other applications, one password per application.

The last password used stays on the clipboard, so you can use <key>⌘-V</key> to paste your it anywhere.

The global password is used to encrypt a file (`~/.chupacabra`) which stores all your passwords for applications and websites.
Chupacabra will ask you only once for your global password until you restart your computer.


Copyright (c) 2013 [Lean Logics](http://leanlogics.com), released under the MIT license


