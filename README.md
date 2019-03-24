# PartyLoud
> A simple tool to do several http/https requests and simulate navigation.

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

PartyLoud is a bash script to create fake internet traffic
to mitigate tracking from hacker on local network or IPS

## Table of contents
* [General info](#general-info)
* [Setup](#setup)
* [Usage](#usage)

## Setup

OS X & Linux:

```sh
git clone https://github.com/realtho/PartyLoud.git
cd PartyLoud
chmod +x partyloud.sh
./partyloud.sh
```

## Usage

To use this script just run it without any argument, in future
I'll add an option to set the number of parallel at start
(currently it is fixed to 7)

To stop the script just press any key
#### DO NOT STOP SCRIPT VIA CTRL-C
if you do so you will kill main process but sub shells will stay alive
and keep sending requests
