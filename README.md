# HHSOJ-WebEdition
Another stupid Online Judge with Java EE version.
# What's it
It's an easy online judge. It's still beta!
# About "hhsoj" folder
We have one sample folder for you. Check it out. **It is recommended to copy the sample folder to your computer when using**

You can use `new File("hhsoj").getAbsolutePath()` to check your hhsoj folder path on your computer.

If "oj.exe" is not in "hhsoj/runtime" folder, a *Library Missing* verdict will be given to every submission. But if "JavaTester.jar" is not in it, a *Judgement Failed* verdict will be given instead.

You can go to the "credits.jsp" and click "View Source" and find your HHSOJ path in source code

# Building
0. System requirement: Windows x64 system with Tomcat9.0 server and JRE.

1. Install g++ compiler, python compiler

2. Download the code and open it in Eclipse EE. It should be a valid Eclipse Project.

3. Deploy the project and start the server and go to your tomcat page and have a look.

4. After the first run, a "hhsoj" folder will be generated at a predicted directory. 

5. Copy the files in "runtime" on Github to "hhsoj" folder. If there's no "runtime" folder in "hhsoj" then create one

6. Create two files:"user.txt" and "psd.txt" in your hhsoj root directory and write your Windows username in "user.txt" , password in "psd.txt". They will be used to create C++ programs. If you want to run the programs securely , please fill in a low-priority user. **Notice that you must enter a user that exists! Or the sandbox may doesn't work properly!**

# Adding problems
1. Create a folder in the "hhsoj/problems" and name it as the problem Id, it should contains only digits.

2. Create a subfolder called "tests" and "arg.txt"

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

- **For HHSOJ version < 1.2** In the "WebContent/statement" folder add a filename called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

- **For HHSOJ version >=1.2** In the problem folder create a file called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

5. You should be seeing it in the problem list

6. To add test cases, just put **input files only** in the "tests" subfolder

7. For details, please take a glance at the sample hhsoj folder

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
# Customizing Announcement
Announcement is the marquee text in index.jsp

You can customize it from 18w23a.Find the file "hhsoj/announcement.txt" and change the words in it. You will see the announcement change.

# Customizing Judging Config

From version 18w35a you can find the file "hhsoj/config.json" then change the settings there
```
{
    "enableCPP11":true, //Whether to open cpp11 or not
    "windowsUsername":"", //the windows system username
    "windowsPassword":"" //the windows system password
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