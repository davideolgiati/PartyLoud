# PartyLoud :sound:
> A simple tool to generate fake web browsing and mitigate traking

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![Screenshot](https://i.imgur.com/cn1eEFs.png)

PartyLoud is a tool to create fake internet traffic
in order to mitigate tracking on local networks.
This project was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

##### :warning: Currently PartyLoud has been only tested on Debian 9 and Mac OSX 10.14 :warning:

## Table of contents

* [Changelog](CHANGELOG.md)
* [Features](#features)
* [Setup](#setup)
* [Usage](#usage)

## Features

- Configurable urls list (partyloud.conf) and blocklist (badwords)
- Multi-threaded request engine (number ot thread are equal to number of urls in partyloud.conf)
- Error recovery mechanism to protect Engines from failures
- Spoofed User Agent prevent from fingerprinting (Each engine has a different user agent)
- Dynamic UI

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
