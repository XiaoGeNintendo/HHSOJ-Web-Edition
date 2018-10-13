/* Verwandlung Online Judge - A cross-platform judge online system
* Copyright (C) 2018 Haozhe Xie <cshzxie@gmail.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*
*                              _ooOoo_
*                             o8888888o
*                             88" . "88
*                             (| -_- |)
*                             O\  =  /O
*                          ____/`---'\____
*                        .'  \\|     |//  `.
*                       /  \\|||  :  |||//  \
*                      /  _||||| -:- |||||-  \
*                      |   | \\\  -  /// |   |
*                      | \_|  ''\---/''  |   |
*                      \  .-\__  `-`  ___/-. /
*                    ___`. .'  /--.--\  `. . __
*                 ."" '<  `.___\_<|>_/___.'  >'"".
*                | | :  `- \`.;`\ _ /`;.`/ - ` : | |
*                \  \ `-.   \_ __\ /__ _/   .-` /  /
*           ======`-.____`-.___\_____/___.-`____.-'======
*                              `=---='
*
*                          HERE BE BUDDHA
*
*/
#define INT_MAX 2147483647

#pragma comment(lib,"ws2_32.lib")
#pragma comment(lib, "IPHLPAPI.lib")
#pragma comment(lib, "Psapi.lib")
#pragma comment(lib, "Userenv.lib")

#include <cstdint> 
#include <future>
#include <iostream>
#include <limits>
#include <sstream>
#include <string>
#include <thread>
#include <string>
#include <map>
#include <fstream>

#include <windows.h>
#include <userenv.h>
#include <psapi.h>
#include <tlhelp32.h>

using namespace std;

/**
* Function Prototypes.
*/
bool setupIoRedirection(std::wstring, std::wstring, HANDLE&, HANDLE&);
void setupStartupInfo(STARTUPINFOW&, HANDLE&, HANDLE&);
bool createProcess(const std::wstring&, const std::wstring&, const std::wstring&, HANDLE&, LPVOID, STARTUPINFOW&, PROCESS_INFORMATION&);
DWORD runProcess(PROCESS_INFORMATION&, int, int, int&, int&);
int getMaxMemoryUsage(PROCESS_INFORMATION&, int);
int getCurrentMemoryUsage(HANDLE&);
long long getMillisecondsNow();
bool killProcess(PROCESS_INFORMATION&);
DWORD getExitCode(HANDLE&);
std::string getErrorMessage(const std::string&);
std::wstring getWideString(const std::string&);
LPWSTR getWideStringPointer(const std::wstring&);
LPCWSTR getConstWideStringPointer(const std::wstring&);
void Java_org_verwandlung_voj_judger_core_Runner_getRuntimeResult(string,string,string,string,string,int,int);

const int SetupIoRedirectionException = 1;
const int CreateProcessException = 2;
const int OK = 0;
const int ArgCountException = 3;

void printResult(map<string, int> mp) {
	ofstream os;
	os.open("v2.txt");
	os << mp["userTime"] << endl;
	os << mp["userdMemory"] << endl;
	os << mp["exitCode"] << endl;
	os << mp["verdict"] << endl;
}

int main(int argc, char** argv) {
	if (argc != 8) {
		map<string, int> result;
		result["userTime"] = 0;
		result["userdMemory"] = 0;
		result["exitCode"] = 0;
		result["verdict"] = ArgCountException;

		printResult(result);
		cout << "Arg Count Failed" << endl;
		return 1;
	}

	string a1 = argv[1];
	string a2 = argv[2];
	string s3 = argv[3];
	string s4 = argv[4];
	string s5 = argv[5];
	int s6 = atoi(argv[6]);
	int s7 = atoi(argv[7]);
	Java_org_verwandlung_voj_judger_core_Runner_getRuntimeResult(a1, a2, s3, s4, s5, s6, s7);

}

/**
* ��ȡ�������н��.
* @param  jCommandLine    - ��ִ�е�������
* @param  jUsername       - Windows�û���
* @param  jPassword       - Windows����
* @param  jInputFilePath  - ִ�г���ʱ�������ļ�·��(��ΪNULL)
* @param  jOutputFilePath - ִ�г���������ļ�·��(��ΪNULL)
* @param  timeLimit       - ����ִ��ʱ������(ms, 0Ϊ������)
* @param  memoryLimit     - ����ִ���ڴ�����(KB, 0Ϊ������)
* @return һ���������н����Map<String, Object>����
*/
void Java_org_verwandlung_voj_judger_core_Runner_getRuntimeResult(string jCommandLine, string jUsername,
	string jPassword, string jInputFilePath, string jOutputFilePath, int timeLimit,
	int memoryLimit) {

	
	std::wstring        commandLine = getWideString(jCommandLine);
	std::wstring        username = getWideString(jUsername);
	std::wstring        password = getWideString(jPassword);
	std::wstring        inputFilePath = getWideString(jInputFilePath);
	std::wstring        outputFilePath = getWideString(jOutputFilePath);

	cout << jCommandLine << " " << commandLine.c_str() << endl;

	HANDLE              hInput = { 0 };
	HANDLE              hOutput = { 0 };
	HANDLE              hToken = { 0 };
	LPVOID              lpEnvironment = NULL;
	PROCESS_INFORMATION processInfo = { 0 };
	STARTUPINFOW        startupInfo = { 0 };

	map<string, int>            result;
	int                timeUsage = 0;
	int                memoryUsage = 0;
	DWORD               exitCode = 127;

	if (!setupIoRedirection(inputFilePath, outputFilePath, hInput, hOutput)) {
		result["userTime"] = timeUsage;
		result["userdMemory"] = memoryUsage;
		result["exitCode"] = exitCode;
		result["verdict"] = SetupIoRedirectionException;

		printResult(result);
		return;
	}
	setupStartupInfo(startupInfo, hInput, hOutput);

	if (!createProcess(commandLine, username, password, hToken, lpEnvironment, startupInfo, processInfo)) {
		result["userTime"] = timeUsage;
		result["userdMemory"] = memoryUsage;
		result["exitCode"] = exitCode;
		result["verdict"] = CreateProcessException;

		printResult(result);
		return;
	}

	exitCode = runProcess(processInfo, timeLimit, memoryLimit, timeUsage, memoryUsage);
	CloseHandle(hInput);
	CloseHandle(hOutput);

	result["userTime"] = timeUsage;
	result["userdMemory"] = memoryUsage;
	result["exitCode"] = exitCode;
	result["verdict"] = OK;
	printResult(result);
}

/**
* �ض����ӽ��̵�I/O.
* @param inputFilePath  - �����ļ�·��
* @param outputFilePath - ����ļ�·��
* @param hInput         - �����ļ����
* @param hOutput        - ����ļ����
*/
bool setupIoRedirection(std::wstring inputFilePath, std::wstring outputFilePath,
	HANDLE& hInput, HANDLE& hOutput) {
	SECURITY_ATTRIBUTES sa;
	sa.nLength = sizeof(sa);
	sa.lpSecurityDescriptor = NULL;
	sa.bInheritHandle = TRUE;

	if (!inputFilePath.empty()) {
		hInput = CreateFileW(inputFilePath.c_str(), GENERIC_READ, 0, &sa,
			OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		if (hInput == INVALID_HANDLE_VALUE) {
			cout << "Invalid handle value" << endl;
			return false;
		}
	}
	if (!outputFilePath.empty()) {
		hOutput = CreateFileW(outputFilePath.c_str(), GENERIC_WRITE, 0, &sa,
			CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
		if (hInput == INVALID_HANDLE_VALUE) {
			cout << "Invalid handle value" << endl;
			return false;
		}
	}

	cout << "Success Redirect" << endl;
	return true;
}

/**
* ����I/O�ض�����Ϣ��������startupInfo.
* @param startupInfo - STARTUPINFOW�ṹ��
* @param hInput      - �ļ�������
* @param hOutput     - �ļ�������
*/
void setupStartupInfo(STARTUPINFOW& startupInfo, HANDLE& hInput, HANDLE& hOutput) {
	startupInfo.cb = sizeof(STARTUPINFOW);
	startupInfo.dwFlags |= STARTF_USESTDHANDLES;
	startupInfo.hStdInput = hInput;
	startupInfo.hStdError = hOutput;
	startupInfo.hStdOutput = hOutput;
}

/**
* ��������.
* @param  commandLine   - ��ִ�е�������
* @param  username      - Windows�û���
* @param  password      - Windows����
* @param  hToken        - a token that represents the specified user
* @param  lpEnvironment - an environment block for the new process
* @param  startupInfo   - a STARTUPINFO structure
* @param  processInfo   - a PROCESS_INFORMATION structure that receives identification
*                         information for the new process, including a handle to the process
* @return �����Ƿ񴴽��ɹ�
*/
bool createProcess(const std::wstring& commandLine, const std::wstring& username,
	const std::wstring& password, HANDLE& hToken, LPVOID lpEnvironment,
	STARTUPINFOW& startupInfo, PROCESS_INFORMATION& processInfo) {
	WCHAR   szUserProfile[256] = L"";
	DWORD   dwSize = sizeof(szUserProfile) / sizeof(WCHAR);
	LPCWSTR lpUsername = getConstWideStringPointer(username);
	LPCWSTR lpDomain = getConstWideStringPointer(L".");
	LPCWSTR lpPassword = getConstWideStringPointer(password);
	LPWSTR  lpCommandLine = getWideStringPointer(commandLine);

	
	if (!LogonUserW(lpUsername, lpDomain, lpPassword, LOGON32_LOGON_BATCH,
		LOGON32_PROVIDER_DEFAULT, &hToken)) {
		cout << "Logon User W failed" << endl;
		return false;
	}
	if (!CreateEnvironmentBlock(&lpEnvironment, hToken, TRUE)) {
		cout << "Create Environment Block Failed" << endl;
		return false;
	}
	if (!GetUserProfileDirectoryW(hToken, szUserProfile, &dwSize)) {
		cout << "Get User Profile Directory Failed" << endl;
		return false;
	}

	
	if (!CreateProcessWithLogonW(lpUsername, lpDomain, lpPassword,
		LOGON_WITH_PROFILE, NULL, lpCommandLine,
		CREATE_UNICODE_ENVIRONMENT | CREATE_SUSPENDED | CREATE_NO_WINDOW,
		lpEnvironment, szUserProfile, &startupInfo, &processInfo)) {

		cout << "Create Process Failed" << endl;
		//cout << commandLine.c_str() << endl;
		cout<<getErrorMessage("Create Process")<<endl;

		return false;
	}

	cout << "Success" << endl;
	return true;
}

/**
* ���н���.
* @param  processInfo - ����������Ϣ��PROCESS_INFORMATION�ṹ��
* @param  timeLimit   - ����ʱʱ������(ms)
* @param  memoryLimit - ����ʱ�ռ�����(KB)
* @param  timeUsage   - ����ʱʱ��ռ��(ms)
* @param  memoryUsage - ����ʱ�ռ�ռ��(ms)
* @return �����˳�״̬
*/
DWORD runProcess(PROCESS_INFORMATION& processInfo, int timeLimit,
	int memoryLimit, int& timeUsage, int& memoryUsage) {
	int  reservedTime = 200;
	auto feature = std::async(std::launch::async, getMaxMemoryUsage, std::ref(processInfo), memoryLimit);

	ResumeThread(processInfo.hThread);
	long long startTime = getMillisecondsNow();
	WaitForSingleObject(processInfo.hProcess, timeLimit + reservedTime);
	long long endTime = getMillisecondsNow();
	timeUsage = endTime - startTime;

	if (getExitCode(processInfo.hProcess) == STILL_ACTIVE) {
		killProcess(processInfo);
	}
	memoryUsage = feature.get();

	return getExitCode(processInfo.hProcess);
}

/**
* ��ȡ����ʱ�ڴ�ռ�����ֵ
* @param  processInfo - ����������Ϣ��PROCESS_INFORMATION�ṹ��
* @param  memoryLimit - ����ʱ�ռ�����(KB)
* @return ����ʱ�ڴ�ռ�����ֵ
*/
int getMaxMemoryUsage(PROCESS_INFORMATION& processInfo, int memoryLimit) {
	int maxMemoryUsage = 0,
		currentMemoryUsage = 0;
	do {
		currentMemoryUsage = getCurrentMemoryUsage(processInfo.hProcess);
		if (currentMemoryUsage > maxMemoryUsage) {
			maxMemoryUsage = currentMemoryUsage;
		}
		if (memoryLimit != 0 && currentMemoryUsage > memoryLimit) {
			killProcess(processInfo);
		}
		Sleep(200);
	} while (getExitCode(processInfo.hProcess) == STILL_ACTIVE);

	return maxMemoryUsage;
}

/**
* ��ȡ�ڴ�ռ�����.
* @param  hProcess - ���̾��
* @return ��ǰ�����ڴ�ʹ����(KB)
*/
int getCurrentMemoryUsage(HANDLE& hProcess) {
	PROCESS_MEMORY_COUNTERS pmc;
	int  currentMemoryUsage = 0;

	if (!GetProcessMemoryInfo(hProcess, &pmc, sizeof(pmc))) {
		return 0;
	}
	currentMemoryUsage = pmc.PeakWorkingSetSize >> 10;

	if (currentMemoryUsage < 0) {
		currentMemoryUsage = INT_MAX >> 10;
	}
	return currentMemoryUsage;
}

/**
* ��ȡ��ǰϵͳʱ��.
* ����ͳ�Ƴ�������ʱ��.
* @return ��ǰϵͳʱ��(�Ժ���Ϊ��λ)
*/
long long getMillisecondsNow() {
	static LARGE_INTEGER frequency;
	static BOOL useQpf = QueryPerformanceFrequency(&frequency);
	if (useQpf) {
		LARGE_INTEGER now;
		QueryPerformanceCounter(&now);
		return (1000LL * now.QuadPart) / frequency.QuadPart;
	}
	else {
		return GetTickCount();
	}
}

/**
* ǿ�����ٽ���(��������ֵʱ).
* @param  processInfo - ����������Ϣ��PROCESS_INFORMATION�ṹ��
* @return ���ٽ��̲����Ƿ�ɹ����
*/
bool killProcess(PROCESS_INFORMATION& processInfo) {
	DWORD           processId = processInfo.dwProcessId;
	PROCESSENTRY32 processEntry = { 0 };
	processEntry.dwSize = sizeof(PROCESSENTRY32);
	HANDLE handleSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

	if (Process32First(handleSnap, &processEntry)) {
		BOOL isContinue = TRUE;

		do {
			if (processEntry.th32ParentProcessID == processId) {
				HANDLE hChildProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processEntry.th32ProcessID);
				if (hChildProcess) {
					TerminateProcess(hChildProcess, 1);
					CloseHandle(hChildProcess);
				}
			}
			isContinue = Process32Next(handleSnap, &processEntry);
		} while (isContinue);

		HANDLE hBaseProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processId);
		if (hBaseProcess) {
			TerminateProcess(hBaseProcess, 1);
			CloseHandle(hBaseProcess);
		}
	}

	if (getExitCode(processInfo.hProcess) == STILL_ACTIVE) {
		return false;
	}
	return true;
}

/**
* ��ȡӦ�ó����˳�״̬.
* 0��ʾ�����˳�, 259��ʾ��������.
* @param  hProcess - ���̵ľ��
* @return �˳�״̬
*/
DWORD getExitCode(HANDLE& hProcess) {
	DWORD exitCode = 0;
	GetExitCodeProcess(hProcess, &exitCode);

	return exitCode;
}

/**
* ��ȡWindows API�쳣��Ϣ.
* @param  apiName - Windows API����
* @return Windows API�쳣��Ϣ
*/
std::string getErrorMessage(const std::string& apiName) {
	LPVOID lpvMessageBuffer;

	FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER |
		FORMAT_MESSAGE_FROM_SYSTEM,
		NULL, GetLastError(),
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		(LPSTR)&lpvMessageBuffer, 0, NULL);

	std::stringstream stringStream;
	std::string errorMessage((LPSTR)lpvMessageBuffer);

	stringStream << "API:     " << apiName << std::endl
		<< "Code:    " << GetLastError() << std::endl
		<< "Message: " << errorMessage << std::endl;
	LocalFree(lpvMessageBuffer);

	return stringStream.str();
}

/**
* ��ȡstd::wstring���͵��ַ���.
* @param  str - std::string���͵��ַ���
* @return wstring���͵��ַ���
*/
std::wstring getWideString(const std::string& str) {
	std::wstring wstr(str.begin(), str.end());
	return wstr;
}

/**
* ��ȡstd::wstring��ӦLPWSTR���͵�ָ��.
* @param  str - std::wstring���͵��ַ���
* @return ��ӦLPWSTR���͵�ָ��
*/
LPWSTR getWideStringPointer(const std::wstring& str) {
	return const_cast<LPWSTR>(str.c_str());
}

/**
* ��ȡstd::wstring��ӦLPCWSTR���͵�ָ��.
* @param  str - std::wstring���͵��ַ���
* @return ��ӦLPCWSTR���͵�ָ��
*/
LPCWSTR getConstWideStringPointer(const std::wstring& str) {
	return str.c_str();
}
