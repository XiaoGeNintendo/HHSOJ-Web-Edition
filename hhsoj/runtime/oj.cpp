#include <iostream>
#include <algorithm>
#include <vector>
#include <set>
#include <queue>
#include <map>
#include <string.h>
#include <math.h>
#include <stdio.h>
#include <deque>
#include <bits/stdc++.h>
//#include "D:\C++\test_lib_projects\testlib.h"
#include <windows.h>
using namespace std;
#define ll long long
#define pii pair<int,int>
#define qi ios::sync_with_stdio(0)

bool debug=true;

/*    *************************************
	  * Written in New Computer           *
	  * The following code belongs to     *
	  * XiaoGeNintendo of HellHoleStudios *
	  *************************************
*/
template<typename T1,typename T2>ostream& operator<<(ostream& os,pair<T1,T2> ptt) {
	os<<ptt.first<<","<<ptt.second;
	return os;
}
template<typename T>ostream& operator<<(ostream& os,vector<T> vt) {
	os<<"{";
	for(int i=0; i<vt.size(); i++) {
		os<<vt[i]<<" ";
	}
	os<<"}";
	return os;
}


/**
	This file does not make sure that the judging server will be protected from dangerous code!!
	Part of the code belongs to CSDN friendly users :) 
	
*/
int main(int argc,char* argv[]) {
	
	int tl=atoi(argv[1]);
	int ml=atoi(argv[2]);
	
	
	//cout<<tl<<" "<<ml<<endl;
	 
	HANDLE hJob=CreateJobObject(NULL,NULL);
	
	JOBOBJECT_BASIC_LIMIT_INFORMATION Job_Limit ;
	memset(&Job_Limit, 0, sizeof(Job_Limit)) ;
	Job_Limit.LimitFlags=JOB_OBJECT_LIMIT_PROCESS_TIME |JOB_OBJECT_LIMIT_WORKINGSET |JOB_OBJECT_LIMIT_ACTIVE_PROCESS ;
	Job_Limit.PerProcessUserTimeLimit.QuadPart = 10000*tl; //子进程执行时间ns(1s=10^9ns)
	Job_Limit.MinimumWorkingSetSize = 1;
	Job_Limit.MaximumWorkingSetSize = 1024*ml;//10MB
	Job_Limit.ActiveProcessLimit = 1;
	SetInformationJobObject(hJob, JobObjectBasicLimitInformation, &Job_Limit, sizeof(Job_Limit));

	JOBOBJECT_BASIC_UI_RESTRICTIONS Job_UI_Limit;
	Job_UI_Limit.UIRestrictionsClass = JOB_OBJECT_UILIMIT_NONE;
	Job_UI_Limit.UIRestrictionsClass |= JOB_OBJECT_UILIMIT_EXITWINDOWS | //阻止进程注销，关机，重启或断开系统电源
	JOB_OBJECT_UILIMIT_READCLIPBOARD | //阻止进程读取剪贴板中的内容。
	JOB_OBJECT_UILIMIT_WRITECLIPBOARD | //阻止进程清除剪贴板中的内容。
	JOB_OBJECT_UILIMIT_SYSTEMPARAMETERS | //阻止进程更改系统参数。
	JOB_OBJECT_UILIMIT_DISPLAYSETTINGS | //进程更改显示设置。
	JOB_OBJECT_UILIMIT_GLOBALATOMS | //为作业指定其专有的全局原子表，并限定作业中的进程只能访问此作业的表。
	JOB_OBJECT_UILIMIT_DESKTOP | //阻止进程创建或切换桌面。
	JOB_OBJECT_UILIMIT_HANDLES ; //阻止作业中的进程使用同一个作业外部的进程所创建的用户对象( 如HWND) 。
	SetInformationJobObject(hJob, JobObjectBasicUIRestrictions, &Job_UI_Limit, sizeof(Job_UI_Limit));

	STARTUPINFO si = { sizeof(si) };
	PROCESS_INFORMATION pi;
	TCHAR szCmdLine[] = TEXT("Program.exe");
	CreateProcess(NULL, szCmdLine, NULL, NULL, FALSE, CREATE_BREAKAWAY_FROM_JOB | CREATE_SUSPENDED, NULL, NULL, &si, &pi);

	AssignProcessToJobObject(hJob, pi.hProcess);

	ResumeThread(pi.hThread);
	CloseHandle(pi.hThread);

	//通过WaitForSingleObject等待正在运行的工作对象,设置好允许使用时间.
	DWORD WaitRe = WaitForSingleObject(hJob,tl*1000);
	
	//Ths file output
	ofstream os;
	os.open("sandbox.txt");
	
	
	if(WaitRe!=WAIT_FAILED) {
		JOBOBJECT_EXTENDED_LIMIT_INFORMATION lpJobObjectInfo;
		DWORD lpReturnLength;
		if(QueryInformationJobObject(hJob,JobObjectExtendedLimitInformation,&lpJobObjectInfo,sizeof(lpJobObjectInfo),&lpReturnLength)) {
			
			os<<lpJobObjectInfo.PeakProcessMemoryUsed/1024<<endl;
			
			DWORD ExitCode=0;
			//TerminateJobObject(Job,0);
			if(GetExitCodeProcess(pi.hProcess,&ExitCode)) {
				os<<ExitCode<<endl;
			}
		}
	} else {
		
		return 1;
		
	}
	TerminateJobObject(hJob,0);//exit

	CloseHandle(pi.hProcess);
	CloseHandle(hJob);

	os.close();
	
	return 0;
}


