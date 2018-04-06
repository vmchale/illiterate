# illiterate

[![Build Status](https://travis-ci.org/vmchale/illiterate.svg?branch=master)](https://travis-ci.org/vmchale/illiterate)

A language-agnostic preprocessor for literate programming. Supports Bird-style
and TeX-style literate programming.

You can easily write build systems with `lit` using the `shake-ext`
[package](http://hackage.haskell.org/package/shake-ext).

## Installation

You can install `atspkg` and `lit` with the following:

```bash
curl -sSl https://raw.githubusercontent.com/vmchale/atspkg/master/bash/install.sh | bash -s
atspkg remote https://github.com/vmchale/illiterate/archive/master.zip
```

## Use

As an example:

```bash
lit literate.lidr > plain.idr
```
