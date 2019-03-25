# PartyLoud :sound:
> A simple tool to do several http/https requests and simulate navigation.

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

![ScreenShoot](https://i.imgur.com/cn1eEFs.png
)

PartyLoud is a bash script to create fake internet traffic
to mitigate tracking from hacker on local network or IPS
This script was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

## Table of contents

* [Changelog](#changelog)
* [Setup](#setup)
* [Usage](#usage)

## Changelog



## Setup

##### :warning: Currently PartyLoud has been only tested on Debian 9 and Mac OSX 10.14. :warning:

Clone the repository:
```sh
git clone https://github.com/realtho/PartyLoud.git
```
Navigate to th directory and make stript executable:
```sh
cd PartyLoud
chmod +x partyloud.sh
```
Run 'partyloud':
```sh
./partyloud.sh
```

## Usage

### Just run it without any argument

```sh
./partyloud.sh
```

In future I'll add an option to set the number of parallel at start
(currently it is fixed to 7)

### To stop the script just press any key
#### DO NOT STOP THE SCRIPT USING CTRL-C
