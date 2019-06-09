# HHSOJ-WebEdition
Another stupid cross-platform Online Judge with Java EE.

Sometimes we call it HellOJ
# What's it
It's an easy online judge. It's still beta!
# About "hhsoj" folder
We have one sample folder for you. Check it out. **It is recommended to copy the sample folder to your computer when using**

You can use `new File("hhsoj").getAbsolutePath()` to check your hhsoj folder path on your computer.

If "oj.exe" is not in "hhsoj/runtime" folder, a *Library Missing* verdict will be given to every submission. But if "JavaTester.jar" is not in it, a *Judgement Failed* verdict will be given instead.

**(Before 18w46a)** You can go to the "credits.jsp" and click "View Source" and find your HHSOJ path in source code

**(After 18w46a)** Go to the admin platform to see the HHSOJ path. **(After 19w08d)** If you didn't copy the hhsoj folder so the admin password may become null. In this situation, just input anything you like and the system will give you the folder path after doing so.

# Building on Linux
0. **Note!!! Linux version is experimental now!! Only CPP can be judged successfully**
 
1. System requirement: Any Linux that runs Java8.

2. Then do the same as Windows. The system will detect your OS.

3. **Note!!! Some functions don't work the same on different OS!**

4. Configure the Sandbox: Find the `/runtime/Linux_config.ini` to change some linux sandbox settings. You can add allowed system call in the file `/runtime/Linux_okcall.cfg` in the following format: `<call Id> := <call Limit>` Spaces are required

5. You'd better use root account to launch the program.

# Building on Windows
0. System requirement: Windows x64 system with Tomcat9.0 server and JRE. You may need to install VC libraries for sandbox to run. 

1. Install g++ compiler, python compiler

2. Download the code and open it in Eclipse EE. It should be a valid Eclipse Project. (You can download the WAR package as well)

3. Deploy the project and start the server and go to your tomcat page and have a look.

4. After the first run, a "hhsoj" folder will be generated at a predicted directory. 

5. Copy the files in "runtime" on Github to "hhsoj" folder. If there's no "runtime" folder in "hhsoj" then create one

6. **(Before 18w35a)** Create two files:"user.txt" and "psd.txt" in your hhsoj root directory and write your Windows username in "user.txt" , password in "psd.txt". They will be used to create C++ programs. If you want to run the programs securely , please fill in a low-priority user. **(After 18w35a)** You need to write the username and password in the config.json 
**Notice that you must enter a user that exists! Or the sandbox may not work properly!**

7. **(After 18w46a)** You will also need to input the admin password and admin username. One only.

# Extra packages
You may need to install the following staffs too
- Python
- Gnu G++
- python robo-browser library

# Trouble Shooting Q&A 
Q1: When judging, a **Number Format Exception** popped out and said **./judge is not a number**

A1: Try using Ubuntu or recompile the Linux Judge.

Q2: When judging, a **Null Pointer Exception** popped out.

A2: This can be caused by many reasons. Check if your hhsoj folder has missed something.


# Adding problems
1. Create a folder in the "hhsoj/problems" and name it as the problem Id, it should contains only digits.

2. Create some subfolders with different names(at least 1) and a text file "arg.txt". **For users below 18w51c, a subfolder called "tests" must be created**

3. In the "arg.txt" input the following things:
```
    Solution=sol.exe //The solution executable file . Put it in the same folder
    Checker=checker.exe //The checker executable file. Please use testlib
    Validator_<testSetName>=validator.exe //The validator for testset <testSetName>. Optional. System will seek it at '/!validators/<value>' where <value> is what you inputed. For details, see "Hacking System Of HHSOJ" part.
    Name=A+b Problem //The problem name for displaying
    TL=1000 //Time Limit in ms
    ML=1000 //Memory Limit in kb
    Tag=math,implementation //Tags. Write it as you like
    Statement_<lang>=statement.jsp //Statement for Language file position. See MultiLanguage part.
    AllLanguage=null|Default;en|English //All Languages Present. See MultiLanguage part.
```
Please don't place trailing/leading spaces/tabs.

4. Check your HHSOJ version and write problem statement in HTML format:

- **For HHSOJ version < 1.1** In the "WebContent/statement" folder add a filename called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

- **For HHSOJ version >=1.1** In the problem folder create a file called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

5. You should be seeing it in the problem list

6. To add test cases, just put **input files only** in the subfolders you created. **before 18w51c, please put the input files only in "tests"**

7. You will be finding that each subfolder will be treated as one testset on the submit page. (**Doesn't work before 18w51c**)

8. To make a testset hidden, please add "!" before its name. Note, these testsets can still be judged as a normal testset if a hacker tries to submit by simulating a POST request. But they won't be appeared in the testset selection area.

For further details, please take a glance at the sample hhsoj folder

# MultiLanguage
HHSOJ Supports translate a statement to several languages to help users understand. To do so you need to firstly write all possible languages in the AllLanguage field in arg.txt in format of below:
`AllLanguage=<lang1Code>|<lang1DisplayName>;<lang2Code>|<lang2DisplayName>;...`
You should not add a ';' after everything ends.

**Code** is for system to find out statement. For example, a language code `ch` will let the system to load thee statement from the value of argument `Statement_ch`.

**DisplayName** is for system to display the language on the website. Choose any you want, but without ';' or '|'.

**null language** a language code null is **must** included in your `AllLanguage` and `Statement_null`. This is the default language when a page is opened. If not presented, may cause `Statement is Not Available` error displayed on website.
 
# Hacking System Of HHSOJ
HHSOJ is a modern Online Judge with a simple Hacking system.

**What's hacking?**

Hacking means using a data to make others' programs go wrong.

**How to enable hacking**
First, you need to write a validator for the testset you want to enable hacking. You should be using a Testlib.h to write it. 

Then compile it and put it in `<problem>/!validators/<filename>`. 

Then write in the problem args.txt:`Validator_<testSetName>=<filename>`. This will let the system try to find your validator in the path.

Then when a user opens a submission detail page, he will be able to hack it.

**This system is still in beta.Please be careful when using it.**

# Contest Rules
This rule will display at every welcome page:
```
All HHSOJ Contests uses the rule that is similar to GCJ rule. That is: 
In each problem, a "small" and a "large" testset will be given. 
If you solved the "small" testset, some points will be given 
If you solved the "large" testset, some points will be given too 
The small testset will be judged during contest 
But the "large" testset will only be tested after the contest 
Be careful that every wrong submission that fails on small testset will cause a loss of 50 points after you have passed the small testset 
Each problem has a minimum score of 0 
All solutions that passes "small" testset will be judged on "large" testset after contest 
If you failed on "large" testset, nth will happen 
The user with the highest score gets higher rank
If two users has the same score, a "tiebreaker" will be used 
the "tiebreaker" is the time of last correct submission that passes the "small" testset you submitted in the contest
If the "tiebreaker" is smaller, the rank is higher 
```
# Adding contests
After 18w52a you can now edit contests. In HHSOJ the contest rules is similar to GCJ rules.
Here are some guides:

1. Create a new folder under "hhsoj/contests". the folder name is the contest Id. Note that the id must be **a number** only
2. In that folder, create a file called **info.json** with the following content:
```
{
    "name":"HHSOJ Alpha Round #1", //The contest name
    "startTime":1542524400000, //The start time. Use the Time Changer tool in HHSOJ to convert readable time and numbers
    "length":3600000, //Length in milliseconds. (3600000ms=1h)
    "scores":{ //Scores of problems
        "A":{ //Problem Index
            "small":100, //Scores of small teset
            "large":300 //Scores of large testset
        },
        "B":{ //Another problem
            "small":300,
            "large":500
        } //... etc
    },
    "authors":["a","XGN"] //the author list
}
``` 

3. Then create some subfolders named as the indices you input in the json file. ("A" "B" ...) and in that folders, create a problem. (You can refer to "Adding a Problem")

4. Add a file called "index.html" in the contest Id folder and write announcement in it.

5. Then the system will start reading your contests! 

By the way, a **full.json** file will be generated after the system found your contest. Don't touch it if you didn't change anything about the contest information. But if you change the information, delete it so that the system will regenerate it.

# Admin Platform
You can login to the admin platform at "/admin/login.jsp", input the adminPassword and adminUsername in the box(you should have filled them in the config.json) then you can enjoy your admin journey at "/admin/platform.jsp" :)

You can
- See the id of all users/submissions/blogs
- See the system directory
- Clears the judging queue with a specified verdict 
- Use the console to change files online
- Toggle Judger Status

# Languages

- Python (Python 3.6)
- Java (Now 1.8)
- C++ (C++11)

# Links & Thanks
The previous buggy version [HHSOJ Desktop Version](https://github.com/XiaoGeNintendo/hhsoj)

Thanks [Voj](https://github.com/hzxie/voj/) for the implementations

Thanks [CSDN](https://www.cnblogs.com/Sugite/articles/4568066.html) for the judger and windows safety protection. (Sorry it's Chinese)

Thanks [Zzzyt](https://github.com/zzzzzzyt) for fixing some bugs and stuff!

You can read more about Testlib here: [Mike Mirzayanov](http://codeforces.com/testlib)

HHS blog here: [HHS Blog](https://blog.hellholestudios.club)

Oh, the highlighter and editor are provided by [Wang Fu Peng](http://www.wangeditor.com/)

The Elo editorial is here [Elo](https://bbs.gameres.com/thread_228018_1_1.html) . (Sorry it's Chinese too).

Thanks for Mike Mirzayanov for the great Codeforces System and API. 

```
Codeforces (c) Copyright 2010-2018 Mike Mirzayanov
The only programming contests Web 2.0 platform
```

The Linux Sandbox is [here](https://github.com/KIDx/Judger)

MathJax is [here](https://www.mathjax.org/)
 
You can donate us by Wechat or Paypal :) Send an issue to ask for the donation link.

About the Code Editor, we used [Ace](https://ace.c9.io/)

# Customizing Announcement
Announcement is the marquee text in index.jsp

You can customize it from 18w23a.Find the file "hhsoj/announcement.txt" and change the words in it. You will see the announcement change.

# Customizing Judging Config

From version 18w35a you can find the file "hhsoj/config.json" then change the settings there
```
{
    "enableCPP11":true, //Whether to open cpp11 or cpp normal
    "windowsUsername":"", //the windows system username
    "windowsPassword":"", //the windows system password
    "adminUsername":"admin", //the admin username (after 18w46a)
    "adminPassword":"admin" //the admin password (after 18w46a)
    "enableRemoteJudge":true, //Enable viewing/submitting problems to Codeforces? (after 18w80a)
    "codeforcesUsername":"", //The Codeforces username the system will submit solutions on. (after 18w80a)
    "codeforcesPassword":"", //The Codeforces password (after 18w80a)
    "queryTime":7200000, //What's the query internal. In Milliseconds. Smaller number means more accurate results but may takes longer time to load pages (after 18w80a)
    "waitTimeout":10, //The allowed time for compiling and judging Java and comparing answers. In seconds. (after 19w24a)
    "clearFolder":false //Clear the folder after each judging?
}
```

# Remote Judge
Remote Judge is a new feature after 18w82c. It allows users to submit/search for problems on [Codeforces](https://codeforces.com) By enable it, you can set "enableRemoteJudge" to true in config.json and fill in the Codeforces username and password.

**Please use this feature carefully because if Codeforces crashes down, HHSOJ may crash down too because of the single-thread judging feature. And it will cause many resource usage**

After 19w32a, HHSOJ supports grabing problem statement from Codeforces. If Remote Judge feature is on, users can visit buffered Codeforces statement directly from HHSOJ. A refresh button under the problem statement page can recrawl the statement to keep it fresh. Each recrawl will send a log message to the console stdout:

`[Refresh Codeforces Problem Statement] request <problemId> from <username> ip=<userIP>`

we added logging to prevent being refreshed too many times at a time by a bad guy. This may cause high traffic.

**But, this feature doesn't block IP. It still may cause large Internet connection if many people are using the feature**

# Rating System of HHSOJ
We used simple Elo rating system for HHSOJ. It is that:
- Each user has an initial rating of 1500
- After each contest, the user's rating is recalculated as following:

we calc ![P](https://di.gameres.com/attachment/forum/201310/28/22251233rnfy3titv31e13.png) where D is your rating minus the oppoent's rating.

Then we get ![We](https://di.gameres.com/attachment/forum/201310/28/2223022qgswjkznbzjjuis.png) for any other user in the contest. 

Let W to be the rank of the user. Then the new rating of the user is ![R](https://di.gameres.com/attachment/forum/201310/28/2223026yywcfwyubbzwb66.png) where Ro is the old rating of the user. Constant K=16

# Compiling Guide
JavaTester.jar : `javac JavaTester.java`

JugderV2 : `Use Microsoft VS2017`

Sandbox4Linux: `make` then put the "Judge" in the runtime folder

# MathJax Support
We support MathJax in blogs,comments,statements,announcements,etc... Almost everywhere! Write $$$ before and after your formula to create MathJax inline. 6 '$'s to create a large formula. **After19w33a only**

**MathJax support is still in Alpha version. Be careful when using it in blogs!**

# External Resource Link
Because of the special design, you cannot link to external resources/items when writing a contest announcement or a problem statement. But after 19w26a you can request a external resource by using the `fetch.jsp`. The usage do as follows:

`<host>/fetch.jsp?path=<file path>&encrypt=<md5 encrypt>`

Where `<host>` is your server host.
`<file path>` is the file path relative to the hhsoj root path.
`<md5 encrypt>` is the md5 encrypt of the file you are requesting.
You can use this method to request a file smaller than 1024*1024 bytes.

For example, to request "announcement.txt" you can write as follows:

`fetch.jsp?path=announcement.txt&encrypt=7dab3eb66f77f478301d1bf90c0fcfde`

The md5 is only a sample. Replace it with real md5 you found.

Note that each time you use this method, a debug information will be displayed on the console. It looks like:

`[External Resource Request]File:<file path>(<absolute file path>) Length:<file length> Given md5:<the md5 in the request header> Expected md5:<the real md5 of the file> Operator:<ip address of the requester>`

# Changelog

We use a code to present each commit. The format is [year] + 'w' + [id] + [type].Where [type] could be :

'a' - System update

'b' - Frontend update

'c' - Judging update

'd' - Bug fix

'e' - Little change

## Version 0.0: The beta version released! Seems without judging system? :P

- 18w02e: Updated LICENSE. First time to write a license all by myself? :D

- 18w03e: README update! You guys have something to read about, hum?

- 18w04e: Upload sample "hhsoj" folder

- 18w05d: Fixed line-breaking problem

- 18w06c: Supports CPP Testing

- 18w07a: Supports Filter

- 18w08b: Finish verdict list

- 18w09b: Support CSS. Thanks, Zzzyt!

- 18w10d: Fixed a little bugs in displaying and logic. Tested some attacking function.

- 18w11b: UI design.

- 18w12c: Supports java testing! Finally!

- 18w13b 18w14d: Auto-refresh when pressing "back" and fixed some bugs in java testing.

- 18w15b: Now Will auto jump to login if you didn't login at submit page

- 18w16b: Add every page a UI template. Improve looking.

- 18w17b: UI design.

- 18w18e: Readme update

- 18w19b: Script attack update

- 18w20b: Add code length limit

- 18w21b: UI design and merge

- 18w22b: Credits Page finished

- 18w23a: Supports Customizing Announcement

- 18w24c: Speed up CPP testing

## Version 1.0: Supports Python testing 

- 18w26a 18w27b: Use json to store user information now! Made UI beautiful

- 18w28a: Read external statement supported

- 18w29a: Finished blog writing. You can write a blog at /writeBlog.jsp which has no entrance

- 18w30d: Fixed that username can have html

- 18w31b: Independent nav.jsp file.

- 18w32a: You can now try viewing the post. While voting and other features will come soon!

- 18w33a: You can now vote for the posts.

- 18w34a: You can now change the user settings and user picture

- 18w35a: You can now change the judging settings at "config.json"

- 18w36e: Update changelog format
  
## Version 1.1: Blog system finished

- 18w37b: Zzzyt's Abobe DW updated.

- 18w38e: Fixed readme typo and license problems

- 18w39d: Fixed a huge bug. Sorry for that. (A web demo has been set up somewhere in the Internet! Hooray!)

- 18w40d: Fixed that after setting the explorer will take you to a 404 page.

- 18w41d: Fixed that the "Submission By Him" doesn't work and some other bugs.

- 18w42b: Zzzyt's Style Update

- 18w43a: Progress bar of testing

- 18w44a: Edit&Delete Post

- 18w45a: Comment System finished

- 18w46a: Admin platform finished!

## Version 1.2: Colorful Community

- 18w47a: Two new tools: TimeChanger & RichtextEditor. They can be accessed at Admin Platform

- 18w48b: Moved the two tools.

- 18w49c: "Wrong answer on test 101" everyone likes this! New verdict displaying rules and system

- 18w50a: Improve system so that it can adopt the contest system

- 18w51c: Custom Testsets are open in submit page! And more fixing!

- 18w52a: Welcome Page finished

- 18w53e: Rule update

- 18w54e: Fixed wrong guide

- 18w55b: Zzzyt's CSS Update

- 18w56a: Comment system reverse and placeholder change and anchor points set.

- 18w57a: HMS Changer and some little changes. Like displaying system time and showing contest time correctly. 

- 18w58d: (Yeah! Finally a 'd') Added security for null files and fixed that user id is always 0 (But in fact it is useless :P)

- 18w59a: Problem viewer update and you can now view problems in contests now!

- 18w60a: You can now see the submission testset in the status page!  

- 18w61c: You can now submit your program in contest and it will judge! But sadly no standings now.

- 18w62b: Zzzyt's CSS Update

- 18w63c: You can now send submissions during contest with the contest submit system! And the grand-new standing system will be displayed at the welcome page! The full contest system is almost there! Please wait for the rating system and the system judge feature.

- 18w64a: Admin now can pend system tests! And users' name changes will reflect to the standing change

- 18w65a: Submit out of competition option has been added

- 18w66b: Be prepared for rating color

- 18w67a: Rating system finished

## Version 1.3: Whole Ending

- 18w68b: ZZZYT's CSS update

- 18w69d: Fixed that time displaying error

- 18w70d: Using long to store length

- 18w71d: Fixed that admin platform will cause NullPointerException

- 18w72e: Update HHSOJ Folder. (but nth was changed in fact)

- 18w73a: You can now send Contest Clarifications... But admin cannot reply to it.

- 18w74a: Delay/Increase Contest Length without modifying the files!! New admin feature added! //100th commit!!

- 18w75a: Admins will now be able to see the clarifications... But they cannot reply yet.

- 18w76e: HHSOJ Folder Update

- 18w77a: Contest Clarification System Finished

- 18w78e: Readme update for 100th commit celebration
 
- 18w79b: XGN's CSS update

- 18w80a: Two new problemsets: Contest Problemset/ Codeforces Problemset

- 18w81a: Be prepared for Codeforces submission

- 18w82c: Supports Remote Judge!

- 18w83c: HHSOJ Update

- 18w84d: Fixed that problem statement and blog contains random characters by setting the charset into utf-8

- 18w85a: Language Graph, Verdict Graph and Rating Graph are added!

## Version 1.5: More graphs

- 19w01a: The first update of 2019! Allows disabling folder-clear after judging program. Allows admins to see/toggle the status of the judging thread.

- 19w02e: HHSOJ folder update

- 19w03a: The admin console system finished! Hooray! Now admins can change the files by the program not the system! 

- 19w04d: Fixed some problem reading problems.

## Version 1.6: Admin console

- 19w05b: CSS

- 19w06d: Fixed that submission.jsp doesn't work

- 19w07d: Security Update: You can't hack the OJ by changing local files now(only for register).

- 19w08b: Windows/Linux Check

- 19w08d: Fixed if you don't know the hhsoj holder and you launched the program for the first time you will be confused.

- 19w09d: Too much log! Deleted some logs!

- 19w10d: Fixed that in Linux, the hhsoj folder cannot be found.

- 19w11d: Fixed that the admin pages are not influenced by 19w10d

- 19w12c: Disabled Stack Option of G++

- 19w13c: Minimizing G++ Compiler Option

- 19w14c: Add source for Linux Judging. Moved Java Tester source

- 19w15c: Finish C++ Linux Testing

- 19w16c: chmod

- 19w17c: Linux C++ Testing Done! But now can only test slowly because of poor implementation

- 19w18c: Faster! Faster! Faster! Linux C++ Testing Done!

## Version 1.7: Linux C++ Testing

- 19w19c: 16 testcases per second! Linux Godly Speed Testing Done!

- 19w20d: UTF-8 Support on Comments

- 19w21a: Delete feature for admin console

- 19w22b: Display Submission Filter

- 19w23a: Ban users in admin platform

- 19w24a: Now can change the compiler wait time through files

- 19w25b: Icon and CSS update

- 19w26a: Add external resource request. (Weird number??!!)

- 19w27d: Fixed that all accepted solution in one contest will be judged

- 19w28b: Auto return login/logout in some places

- 19w29d: Fixed some security bugs

- 19w30d: Fixed that in remote judge memory consumed will *1024

- 19w31a: User Search Feature (HHSOJ Monthly Update March 2019)

## Version 1.8: Marh Update of 2019

- 19w32a: Display Codeforces Statement on HHSOJ with buffer!

- 19w33a: The MathJax support for everywhere in HHSOJ

- 19w34e: Fixed some typo in readme

- 19w35b: Added color for solved problems and attempted problems

- 19w36a: Attempted & Solved problems shown on Users' page

## Version 1.9: Remote Judge Update

- 19w37b: Bootstrap support

- 19w38b: no-refresh-needed on status page

- 19w39b: Folded the tools

## Version 1.10: Auto refreshing status page

- 19w40c: Make Judger Abstract for easy changing

- 19w41c: hacking system for Windows

- 19w42d: Fixed bugs of updateStatus.jsp

- 19w43d: Some random bug fix

## Version 1.11: Hacking System For All

- 19w44d: Quick Fix of the issue #4 and #5

- 19w45a: Preference System For Showing. **Undone**

- 19w46a: Code Editor For Submit

- 19w47d: A bug fix of fix of #4

- 19w48a: Code Editor For Contest Submission

- 19w49d: Fixed some NPE

- 19w50a: More preference that does nothing :P

## Version 1.12: Ace Editor

- 19w51c: Custom Submit Feature For Windows-CPP

- 19w52c: Custom Submit Feature For Linux-CPP

## Version 1.13: Custom Submit Feature

- 19w53a: Use CDN instead of copying Wang Editor

- 19w54a: Stop using Wang's Highlighter and replace by Ace.

- 19w55e: getoj.py Added for installing the oj by one key (For linux)

- 19w56e: getoj.sh Added for installing the oj by one key (For linux)

- 19w57d: Bug fix of live status cannot run

- 19w58d: Fixed some random resource bug

- 19w59e: Fixed typo

- 19w60a: User talk system

## Version 1.14: User talk system

- 19w61a: Problem Statement Language System

- 19w62a: Admin Download System... (Remote Download)

- 19w63a: Admin Easy Update Problem System!

## Version 1.15: Language System

- 19w64d: Fixed bugs

- 19w65e: Update HHSOJ folder

## Version 1.15.1: Bug Fix

- 19w66c: Remote Judge Update
