# PartyLoud :sound:
> A simple tool to generate fake web browsing and mitigate tracking

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![Screenshot](https://i.imgur.com/cn1eEFs.png)

PartyLoud is a tool to create fake internet traffic
in order to mitigate tracking on local networks.  
The idea behind this script is that if you make a lot of noise on the 
network (in form of http requests) it wold be less easy for a attacker to
track your real navigation.  

This project was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

##### :warning: Currently PartyLoud has been only tested on Debian 9 and Mac OSX 10.14 :warning:

## Table of contents

* [Changelog](CHANGELOG.md)
* [Features](#features)
* [Setup](#setup)
* [Usage](#usage)
* [FAQ] (#faq)

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

## FAQ

<details>
  <summary>Isn't this literally just a cli based frontend to curl?</summary>
  <p>The core of the script is a curl request, but this tool does more than that. When you run the script, several threads are started. Each thread makes a different Http request and parse the output to choose the next url, simulating a navigation. Unless user stop the script (either pressing enter or via CTRL-C), it will stay alive</p>
</details>

<details>
  <summary>Is error recovery mechanism based on try - catches? </summary>
  <p>Try-catch mechanism doesn't really exist in bash, error recovery mechanism is an elegant way to say that if the http request return a status code starting with 4 or 5 (error) the script will use a backup-url on order to continue execution normally</p>
</details>

<details>
  <summary>Can I fork your project?</summary>
  <p>Look here: https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3) 😉</p>
</details>

<details>
  <summary>How easy is this fake traffic to detect?</summary>
  <p>Unfortunatly it's preatty easy, but keep in mind that this is a beta release and in next releases I'll fix this "issue"</p>
</details>
