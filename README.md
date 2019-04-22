<h1 align="center">
    Partyloud
</h1>

> Get your privacy back, generate fake web browsing and mitigate tracking

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![CodeFactor](https://www.codefactor.io/repository/github/realtho/partyloud/badge)](https://www.codefactor.io/repository/github/realtho/partyloud)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/realtho/PartyLoud.svg)  
![GitHub last commit](https://img.shields.io/github/last-commit/realtho/PartyLoud.svg)  
![GitHub](https://img.shields.io/github/license/realtho/Partyloud.svg)  
![GitHub stars](https://img.shields.io/github/stars/realtho/PartyLoud.svg?style=social)  
  
PartyLoud is a highly configurable and straightforward free tool that help you to prevent tracking directly from linux terminal, no special skills required, once started you can forget it is running. It provides several flags, each flag let you customize you experience and change PartyLoud behaviour according to your needs. 

![Screenshot](https://i.imgur.com/cn1eEFs.png)

Please [submit bugs and feature requests](https://github.com/realtho/PartyLoud/issues) and help me to continuously improve this project.  
For questions / feedbacks please contact me [Here](https://www.reddit.com/message/compose/?to=Tho_real)

- **Simple.** 3 files only, no installation required, just clone this repo an you're ready to go.
- **Powerful.** Thread-based navigation.
- **Stealthy.** Optimized to emulate user navigation.
- **Portable.** You can use this script on every unix-based OS.

This project was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

## `Contents`

* [Changelog](CHANGELOG.md)
* [Features](#features)
* [Setup](#setup)
* [Usage](#usage)
* [FAQ](#faq)

## 🚀 `Features`

- Configurable urls list (partyloud.conf) and blocklist (badwords)
- Multi-threaded request engine (number ot thread are equal to number of urls in partyloud.conf)
- Error recovery mechanism to protect Engines from failures
- Spoofed User Agent prevent from fingerprinting (Each engine has a different user agent)
- Dynamic UI

## 🎉 `Setup`

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

## 📋 `Usage`

```sh
Usage: ./partyloud.sh [options...]

-l --url-list     read URL list from specified FILE
-b --blocklist    read blocklist from specified FILE
-p --http-proxy   set a HTTP proxy
-s --https-proxy  set a HTTPS proxy
-h --help         dispaly this help
```

##### To stop the script press either enter or CRTL-C

## 📖 `FAQ`

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

<details>
  <summary>What badwords is doing?</summary>
  <p>badwords is just a list of keywords used to filter urls in order to prevent 404s and non-html contents (like images, css, js). You can create your own, but, unless you have special needs, I recommend you to use default one or at least to use it as a template</p>
</details>

<details>
  <summary>What partyloud.conf is doing?</summary>
  <p>partyloud.conf is just a list of root urls used to start fake navigation, you can create your own conf file, but pay attention, the more url you add, the more thread you start. This is an "open issue", next releases will come with a max thread number in order to avoid fork bombs (https://www.geeksforgeeks.org/fork-bomb/)</p>
</details>
