# PartyLoud :sound:
> A simple tool to do several HTTP / HTTPS requests and simulate navigation

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![ScreenShoot](https://i.imgur.com/cn1eEFs.png
)

PartyLoud is a bash script to create fake internet traffic
to mitigate tracking from hacker on local network or IPS inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

##### :warning: Currently PartyLoud has been only tested on Debian 9 and Mac OSX 10.14. :warning:

## Table of contents

* [Changelog](CHANGELOG.md)
* [Setup](#setup)
* [Usage](#usage)

## Setup

Clone the repository:
```sh
git clone https://github.com/realtho/PartyLoud.git
```
Navigate to the directory and make the script executable:
```sh
cd PartyLoud
chmod +x partyloud.sh
```
Run 'partyloud':
```sh
./partyloud.sh
```

## Usage

##### Just run it without any argument

```sh
./partyloud.sh
```

##### To stop the script just press enter
