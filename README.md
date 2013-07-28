chupacabra
==========

[![Gem Version](https://badge.fury.io/rb/chupacabra.png)](http://badge.fury.io/rb/chupacabra)
[![Build Status](https://travis-ci.org/dawid-sklodowski/chupacabra.png)](https://travis-ci.org/dawid-sklodowski/chupacabra)

Personal crypto pass 

Chupacabra is password generator and storage, easily accessible via system vide keyboard shortcut.  It reads URL from your active browser and puts your password for given domain into clipboard. If password doesn't exist yet, it will generate random 32 characters password which looks like this: ```pY9)YjiU^cEqzrhz#i(@qt4zu(!NT3No```

Currently it works with MacOs only


### Installation
```sudo /usr/bin/gem install chupacabra``` # Install gem

```chupacabra --install``` # Hook chupacabra into MacOs

```System Preferences -> Keyboard -> Keyboard Shortcuts -> Services -> Chupacabra``` # Create Keyboard Shortcut (I like cmd-K)