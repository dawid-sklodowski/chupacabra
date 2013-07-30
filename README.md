chupacabra
==========

[![Gem Version](https://badge.fury.io/rb/chupacabra.png)](http://badge.fury.io/rb/chupacabra)
[![Build Status](https://travis-ci.org/dawid-sklodowski/chupacabra.png)](https://travis-ci.org/dawid-sklodowski/chupacabra)
[![Code Climate](https://codeclimate.com/github/dawid-sklodowski/chupacabra.png)](https://codeclimate.com/github/dawid-sklodowski/chupacabra)

Personal crypto pass 

Chupacabra is password generator and storage, easily accessible via system vide keyboard shortcut.  It reads URL from your active browser and puts your password for given domain into clipboard. If password doesn't exist yet, it will generate random 32 characters password which looks like this: ```pY9)YjiU^cEqzrhz#i(@qt4zu(!NT3No```

Currently it works with MacOs only


### Installation
```sudo /usr/bin/gem install chupacabra``` # Install gem

```chupacabra --install``` # Hook chupacabra into MacOs

```System Preferences -> Keyboard -> Keyboard Shortcuts -> Services -> Chupacabra``` # Create Keyboard Shortcut (cmd-K works with most browsers)

### Usage
While being in your browser or other application press keyboard shortcut that you assigned to chupacabra.

It will first ask you for your chupacabra global password and then paste your password for you (into field you have focused in).

### How it works
Global chupacabra password encrypts a file (~/.chupacabra), which stores all your passwords for applications and websites.
Chupacabra will ask you only once for your global password until you restart your computer.

When you press chupacabra keyboard shortcut, password is being fetched from encrypted storage or new one is generated

For web browsers you will have one password stored per domain. For other applications -- one password per application.

Password stays in clipboard, so you can use ```cmd-v``` to paste your it anywhere.
