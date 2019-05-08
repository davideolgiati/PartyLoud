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
  <!-- License -->
  <a href="http://makeapullrequest.com">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg"
      alt="PRs Welcome" />
  </a>
  <br />
</div>
  
<p align="center">
<br />
PartyLoud is a highly configurable and straightforward free tool that helps you prevent tracking directly from your linux terminal, no special skills required. Once started, you can forget it is running. It provides several flags; each flag lets you customize your experience and change PartyLoud behaviour according to your needs.
<br />
<img src="https://i.imgur.com/cPO0X1U.png"
      alt="Screenshot" />
</p>

<p align="center">
<b>Please <a href="https://github.com/realtho/PartyLoud/issues">submit bugs and feature requests</a> and help me to continuously improve this project.</b><br />
For questions / feedbacks please contact me <a href="https://www.reddit.com/message/compose/?to=Tho_real">Here</a><br />
<br />
</p>  

- **Simple.** 3 files only, no installation required, just clone this repo an you're ready to go.
- **Powerful.** Thread-based navigation.
- **Stealthy.** Optimized to emulate user navigation.
- **Portable.** You can use this script on every unix-based OS.

This project was inspired by [noisy.py](https://github.com/1tayH/noisy "noisy.py")

### [📝 Changelog](CHANGELOG.md)

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
- Random DNS Mode : each request is done on a different DNS Server
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

-d --dns <file>                    DNS Servers are sourced from specified FILE,
                                   each request will use a different DNS Server
                                   in the list
                                   !!WARNING THIS FEATURE IS EXPERIMENTAL!!
                                   !!PLEASE LET ME KNOW ISSUES ON GITHUB !!
-l --url-list <file>               read URL list from specified FILE
-b --blocklist <file>              read blocklist from specified FILE
-p --http-proxy <http://ip:port>   set a HTTP proxy
-s --https-proxy <https://ip:port> set a HTTPS proxy
-n --no-wait                       disable wait between one request and an other
-h --help                          dispaly this help
```

##### To stop the script press either enter or CRTL-C

##  ⚠️ `File Specifications`

<p align="center">
<b>In current release there is no input-validation on files.</b><br />
If you find bugs or have suggestions on how to improve this features please help me  by opening issues on GitHub <br />
<br />
</p>

### Intro

###### If you don’t have special needs , default config files are just fine to get you started.  
  
Default files are located in:

* [badwords](badwords)
* [partyloud.conf](partyloud.conf)
* [DNSList](DNSList)

Please note that file name and extension are not important, just content of files matter  
  
#### [badwords](badwords) - Keywords-based blocklist
  
[badwords](badwords) is a keywords-based blocklist used to filter non-HTML content, images, document and so on.  
The default config as been created after several weeks of testing. If you really think you need a custom blocklist, my suggestion is to start by copy and modifying default config according to your needs.  
Here are some hints on how to create a great blocklist file:
  
| DO ✅ | DONT 🚫 |
| ------------- | ------------- |
| Use only ASCII chars  | Define one-site-only rules |
| Try to keep the rules as general as possible | Define case-sensitive rules |
| Prefer relative path | Place more than one rule per line |
  
#### [partyloud.conf](partyloud.conf) - ULR List
  
[partyloud.conf](partyloud.conf) is a ULR List used as starting point for fake navigation generators.  
The goal here is to create a good list of sites containing a lot of URLs.  
Aside suggesting you not to use google, youtube and social networks related links, I've really no hints for you.  
###### Note #1 - To work properly the URLs must be [well-formed](https://earthsci.stanford.edu/computing/hosting/urlsyntax/index.php)  
###### Note #2 - Even if the file contains 1000 lines only 10 are used (first 10, working on randomness)  
###### Note #3 - Only one URL per line is allowed
  
#### [DNSList](DNSList) - DNS List
  
[DNSList](DNSList) is a List of DNS used as argument for random DNS feature. Random DNS is not enable by default, so the “default file” is really just a guide line and a test used while developing the function to se if everything was working as expected.   
The only suggestion here is to add as much address as possible to increase randomness.  
###### Note #1 - Only one address per line is allowed
  
## 📖 `FAQ`

<details>
  <summary>Isn't this literally just a cli based frontend to curl?</summary>
  <p><br />The core of the script is a curl request, but this tool does more than that. When you run the script, several threads are started. Each thread makes a different http request and parses the output to choose the next url, simulating web navigation. Unless the user stops the script (either pressing enter or via CTRL-C), it will stay alive.</p>
</details>

<details>
  <summary>How does the error recovery mechanism work? </summary>
  <p><br />Error recovery mechanism is an elegant way to say that if the http request returns a status code starting with 4 or 5 (error), the script will use a backup-url on order to continue normal execution.</p>
</details>

<details>
  <summary>May I fork your project?</summary>
  <p><br />Look <a href="https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)">Here</a> 😉</p>
</details>

<details>
  <summary>How easy is this fake traffic to detect?</summary>
  <p><br />Unfortunately it's pretty easy, but keep in mind that this is a beta and I'll fix this "issue" in upcoming releases.</p>
</details>

<details>
  <summary>What does badwords do?</summary>
  <p><br />badwords is just a list of keywords used to filter urls in order to prevent 404s and traversing non-html content (like images, css, js). You can create your own, but, unless you have special needs, I recommend you use the default one or at least use it as a template.</p>
</details>

<details>
  <summary>What does partyloud.conf do?</summary>
  <p><br />partyloud.conf is just a list of root urls used to start the fake navigation. You can create your own conf file, but pay attention that the more urls you add, the more threads you start. This is an "open issue". Upcoming releases will come with a max thread number in order to avoid <a href="https://www.geeksforgeeks.org/fork-bomb/">Fork Bombs</a>.</p>
</details>
