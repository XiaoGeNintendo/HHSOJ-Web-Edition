# HHSOJ-WebEdition
Another stupid Online Judge with Java EE version.
# What's it
It's an easy online judge. It's still beta!
# About "hhsoj" folder
We have one sample folder for you. Check it out. **Note that the files in runtime folder must be copied into your hhsoj folder**

You can use `new File("hhsoj").getAbsolutePath()` to check your hhsoj folder path on your computer.

If "oj.exe" is not in "hhsoj/runtime" folder, a *Library Missing* verdict will be given to every submission. But if "Judger.jar" is not in it, a *Judgement Failed* verdict will be given instead.

You can go to the "credits.jsp" and click "View Source" and find your HHSOJ path in source code

# Building
0. Build on Windows

1. Install Tomcat, java 8, g++ compiler, python compiler

2. Download the code and open it in Eclipse EE. It should be a valid Eclipse Project.

3. Deploy the project and start the server and go to your tomcat page and have a look.

4. After the first run, a "hhsoj" folder will be generated at a predicted directory. ("desktop" maybe)

5. Copy the files in "runtime" on Github to "hhsoj" folder. If there's no "runtime" folder in "hhsoj" create one

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

4.In the "WebContent/statement" folder add a filename called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

5. You should be seeing it in the problem list

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
# Changelog
Version 0.1: The beta version released! Seems without judging system? :P

Version 0.2: Updated LICENSE. First time to write a license all by myself? :D

Version 0.3: README update! You guys have something to read about, hum?

Version 0.4: Upload sample "hhsoj" folder

Version 0.5: Fixed line-breaking problem

Version 0.6: Supports CPP Testing

Version 0.7: Supports Filter

Version 0.8: Finish verdict list

Version 0.9: Support CSS. Thanks, Zzzyt!

Version 0.10: Fixed a little bugs in displaying and logic. Tested some attacking function.

Version 0.11: UI design.

Version 0.12: Supports java testing! Finally!

Version 0.13: Auto-refresh when pressing "back" and fixed some bugs in java testing.

Version 0.14: Now Will auto jump to login if you didn't login at submit page

Version 0.15: Add every page a UI template. Improve looking.

Version 0.16: UI design.

Version 0.17: Readme update

Version 0.18: Script attack update

Version 0.19: Add code length limit

Version 0.20: UI design and merge

Version 0.21: Credits Page finished