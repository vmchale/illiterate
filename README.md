# illiterate

[![Build Status](https://travis-ci.org/vmchale/illiterate.svg?branch=master)](https://travis-ci.org/vmchale/illiterate)

A language-agnostic preprocessor for literate programming. Supports Bird-style
and TeX-style literate programming.

The secondary goal of this project is to advance the state-of-the art for ATS
programming.

## Installation

### Script

You can install with

```bash
curl https://raw.githubusercontent.com/vmchale/illiterate/master/bash/install.sh | sh -s
```

### Releases

You can find releases for select platforms
[here](https://github.com/vmchale/illiterate/releases).

### Building From Source

You can install `atspkg` and `lit` with the following:

```bash
curl -sSl https://raw.githubusercontent.com/vmchale/atspkg/master/bash/install.sh | bash -s
atspkg remote https://github.com/vmchale/illiterate/archive/master.zip
```

If you want to hack on the source:

```bash
git clone git@github.com:vmchale/illiterate.git
cd illiterate/
atspkg build
```

### Manpages

If you install [pandoc](http://pandoc.org/installing.html), manpages will be
automatically generated when running the above. You can view them with

```bash
man lit
```

## Use

As an example:

```bash
lit literate.lidr > plain.idr
```
