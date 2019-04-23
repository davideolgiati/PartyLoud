<h1 align="center">
Partyloud
</h1>

<p align="center">
Get your privacy back<br>
Generate fake web browsing and mitigate tracking 
</p>

<div align="center">
  <br />
  <!-- made-with-bash -->
  <a href="https://www.gnu.org/software/bash/">
    <img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"
      alt="made-with-bash" />
  </a>
  <!-- CodeFactor -->
  <a href="https://www.codefactor.io/repository/github/realtho/partyloud">
    <img src="https://www.codefactor.io/repository/github/realtho/partyloud/badge"
      alt="CodeFactor" />
  </a>
  <!-- GitHub code size in bytes -->
  <a href="#">
    <img src="https://img.shields.io/github/languages/code-size/realtho/PartyLoud.svg"
      alt="GitHub code size in bytes" />
  </a>
  <br />
  <!-- GitHub last commit -->
  <a href="#">
    <img src="https://img.shields.io/github/last-commit/realtho/PartyLoud.svg"
      alt="Last commit" />
  </a>
  <!-- License -->
  <a href="#">
    <img src="https://img.shields.io/github/license/realtho/Partyloud.svg"
      alt="License" />
  </a>
  <br />
</div>
  
<p align="center">
<br />
PartyLoud is a highly configurable and straightforward free tool that help you to prevent tracking directly from linux terminal, no special skills required, once started you can forget it is running. It provides several flags, each flag let you customize you experience and change PartyLoud behaviour according to your needs.
<br />
<img src="https://i.imgur.com/cPO0X1U.png"
      alt="Screenshot" />
</p>

Please [submit bugs and feature requests](https://github.com/realtho/PartyLoud/issues) and help me to continuously improve this project.  
For questions / feedbacks please contact me [Here](https://www.reddit.com/message/compose/?to=Tho_real)

- **Simple.** 3 files only, no installation required, just clone this repo an you're ready to go.
- **Powerful.** Thread-based navigation.
- **Stealthy.** Optimized to emulate user navigation.
- **Portable.** You can use this script on every unix-based OS.

This project was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

## `Contents`

* [Changelog](CHANGELOG.md)
* [How It Works](#howitworks)
* [Features](#features)
* [Setup](#setup)
* [Usage](#usage)
* [FAQ](#faq)

## ⚙️ `How It Works`

1. URLs and keywords are loaded (either from partyloud.conf and badwords or from user-defined files)
2. If proxy flag has been used, proxy config will be tested
3. For each URL in ULR-list a thread is started, each thread as an [user agent](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent) associated
4. Each thread will start by sending an HTTP request to the given URL
5. The response if filtered using the keywords in order to prevent 404s and malformed URLs
6. A new URL is choosen from the list generated after filering
7. Current thread sleeps for a random time
8. Actions from 4 to 7 are repeated using the new URL until user send kill signal (CTRL-C or enter key) 

## 🚀 `Features`

- Configurable urls list and blocklist
- Multi-threaded request engine (# of thread are equal to # of urls in partyloud.conf)
- Error recovery mechanism to protect Engines from failures
- Spoofed User Agent prevent from fingerprinting (each engine has a different user agent)
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
  <p><br />The core of the script is a curl request, but this tool does more than that. When you run the script, several threads are started. Each thread makes a different Http request and parse the output to choose the next url, simulating a navigation. Unless user stop the script (either pressing enter or via CTRL-C), it will stay alive</p>
</details>

<details>
  <summary>How error recovery mechanism works? </summary>
  <p><br />Error recovery mechanism is an elegant way to say that if the http request return a status code starting with 4 or 5 (error) the script will use a backup-url on order to continue execution normally</p>
</details>

<details>
  <summary>Can I fork your project?</summary>
  <p><br />Look <a href="https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)">Here</a> 😉</p>
</details>

<details>
  <summary>How easy is this fake traffic to detect?</summary>
  <p><br />Unfortunatly it's preatty easy, but keep in mind that this is a beta release and in next releases I'll fix this "issue"</p>
</details>

<details>
  <summary>What badwords is doing?</summary>
  <p><br />badwords is just a list of keywords used to filter urls in order to prevent 404s and non-html contents (like images, css, js). You can create your own, but, unless you have special needs, I recommend you to use default one or at least to use it as a template</p>
</details>

<details>
  <summary>What partyloud.conf is doing?</summary>
  <p><br />partyloud.conf is just a list of root urls used to start fake navigation, you can create your own conf file, but pay attention, the more url you add, the more thread you start. This is an "open issue", next releases will come with a max thread number in order to avoid <a href="https://www.geeksforgeeks.org/fork-bomb/">Fork Bombs</a></p>
</details>
