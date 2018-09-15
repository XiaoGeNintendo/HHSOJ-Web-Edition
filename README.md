# HHSOJ-WebEdition
Another stupid Online Judge with Java EE version.
# What's it
It's an easy online judge. It's still beta!
# About "hhsoj" folder
We have one sample folder for you. Check it out. **Note that the files in runtime folder must be copied into your hhsoj folder**

You can use `new File("hhsoj").getAbsolutePath()` to check your hhsoj folder path on your computer.

If "oj.exe" was not in "hhsoj/runtime" folder, a *Library Missing* verdict will be given to every submission
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

4.In the "WebContent/problems" folder add a filename called `<statement>` where the `<statement>` is what you filled in "Statement=xx" and write all the problem statement there.

5. You should be seeing it in the problem list
# Language
    - Python 
    - Java 
    - C++
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