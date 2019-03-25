# PartyLoud :sound:
> A simple tool to do several http / https requests and simulate navigation

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![ScreenShoot](https://i.imgur.com/cn1eEFs.png
)

PartyLoud is a bash script to create fake internet traffic
to mitigate tracking from hacker on local network or IPS
This script was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

##### :warning: Currently PartyLoud has been only tested on Debian 9 and Mac OSX 10.14. :warning:

## Table of contents

* [Changelog](#changelog)
* [Setup](#setup)
* [Usage](#usage)

## Changelog

## [0.0.5] - 2019-03-21
### Added
- now each partyloud engine wait a pseudo-randomic amount of time before
making a new request to prevent anti-DDoS mechanism triggering (Thx to
[Ale Sala](https://www.instagram.com/ale.sala.97/ "Ale Sala"))

### Changed
- Added random User Agents to cURL requests

## [0.0.3] - 2019-03-20
### Added
- Internal Engine is now complete and operative
- cURL based requests
- HTML response parsed using grep

### Changed
- Fixed number of processes to 7

### Removed
- noisy.py is now no more nesessary
- removed user-defined number of processes

## [0.0.2] - 2019-03-18
### Changed
- Started migration from noisy.py to internel Egnine

## [0.0.1] - 2019-03-17
### Added
- Initilal Alpha
- Added a while loop to start a used defined number of noisy.py process

## Setup

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

##### Just run it without any argument

```sh
./partyloud.sh
```

In future I'll add an option to set the number of parallel at start
(currently it is fixed to 7)

##### To stop the script just press any key
:warning: Do not stop this script using CTRL-C
