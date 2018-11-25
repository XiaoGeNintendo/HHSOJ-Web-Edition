# HHSOJ-WebEdition
Another stupid Online Judge with Java EE version.
# What's it
It's an easy online judge. It's still beta!
# About "hhsoj" folder
We have one sample folder for you. Check it out. **It is recommended to copy the sample folder to your computer when using**

You can use `new File("hhsoj").getAbsolutePath()` to check your hhsoj folder path on your computer.

If "oj.exe" is not in "hhsoj/runtime" folder, a *Library Missing* verdict will be given to every submission. But if "JavaTester.jar" is not in it, a *Judgement Failed* verdict will be given instead.

**(Before 18w46a)** You can go to the "credits.jsp" and click "View Source" and find your HHSOJ path in source code

**(After 18w46a)** Go to the admin platform to see the HHSOJ path

# Building
0. System requirement: Windows x64 system with Tomcat9.0 server and JRE. You may need to install VC libraries for sandbox to run.

1. Install g++ compiler, python compiler

2. Download the code and open it in Eclipse EE. It should be a valid Eclipse Project. (You can download the WAR package as well)

3. Deploy the project and start the server and go to your tomcat page and have a look.

4. After the first run, a "hhsoj" folder will be generated at a predicted directory. 

5. Copy the files in "runtime" on Github to "hhsoj" folder. If there's no "runtime" folder in "hhsoj" then create one

6. **(Before 18w35a)** Create two files:"user.txt" and "psd.txt" in your hhsoj root directory and write your Windows username in "user.txt" , password in "psd.txt". They will be used to create C++ programs. If you want to run the programs securely , please fill in a low-priority user. **(After 18w35a)** You need to write the username and password in the config.json 
**Notice that you must enter a user that exists! Or the sandbox may doesn't work properly!**

7. **(After 18w46a)** You will also need to input the admin password and admin username. One only.

# Adding problems
1. Create a folder in the "hhsoj/problems" and name it as the problem Id, it should contains only digits.

2. Create some subfolders with different names(at least 1) and a text file "arg.txt". **For users below 18w51c, a subfolder called "tests" must be created**

3. In the "arg.txt" input the following things:

```
    Solution=sol.exe //The solution file. Put it in the same folder
    Checker=checker.exe //The checker file. Please use testlib
    Name=A+b Problem //The problem name for displaying
    TL=1000 //Time Limit in ms
    ML=1000 //Memory Limit in kb
    Tag=math,implementation //Tags. Write it as you like
    Statement=statement.jsp //Statement file position
```

4. Check your HHSOJ version and write problem statement in HTML format:

- **For HHSOJ version < 1.1** In the "WebContent/statement" folder add a filename called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

- **For HHSOJ version >=1.1** In the problem folder create a file called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

5. You should be seeing it in the problem list

6. To add test cases, just put **input files only** in the subfolders you created. **before 18w51c, please put the input files only in "tests"**

7. You will be finding that each subfolder will be treated as one testset on the submit page. (**Don't happen before 18w51c**)

For further details, please take a glance at the sample hhsoj folder

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

My blog is here: [Rubbish Blog](https://xgns-blog.000webhostapp.com)

Oh, the highlighter and editor are provided by [Mr.Wang](http://www.wangeditor.com/)

You can donate us by Wechat or Paypal :) But that's useless, isn't it? So the donate address will not be public.

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
}
```

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