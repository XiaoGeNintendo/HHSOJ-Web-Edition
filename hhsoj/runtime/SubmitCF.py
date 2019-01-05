# Codeforces Submit Tool
# By XGN from HHS
# Inspired From Idne (https://github.com/endiliey/idne)
# argument: autoSubmit.py <CF username> <CF password> <ProblemID> <Code> <Lang>

'''
Exit code:

101 - Login Failed : Wrong password
102 - Login Failed : Unknown

201 - Submit File Not Found
202 - Submit Failed

301 - not enough argument
'''

import requests
from robobrowser import RoboBrowser
import sys

print("Sys argv:",sys.argv)

if len(sys.argv)<6:
    print("Too less argument")
    sys.exit(301)

# Main function
b=RoboBrowser(parser="html.parser")
b.open("https://codeforces.com/enter")

form=b.get_form("enterForm")
form["handleOrEmail"]=sys.argv[1]
form["password"]=sys.argv[2]
b.submit_form(form)

print("Login")
try:
    checks = list(map(lambda x: x.getText()[1:].strip(),
        b.select('div.caption.titled')))
    if sys.argv[1] not in checks:
        print("failed")
        #click.secho('Login Failed.. Wrong password.', fg = 'red')
        sys.exit(101)
except Exception as e:
    #click.secho('Login Failed.. Maybe wrong id/password.', fg = 'red')
    print(e)
    sys.exit(102)

print("Submit")
b.open("https://codeforces.com/problemset/submit")
form2=b.get_form(class_="submit-form")
form2["submittedProblemCode"]=sys.argv[3]

try:
    form2["sourceFile"]=sys.argv[4]
except Exception as e:
    print("Error:",e)
    sys.exit(201)

if sys.argv[5]=="cpp":
    form2["programTypeId"]="42"
if sys.argv[5]=="java":
    form2["programTypeId"]="36"
if sys.argv[5]=="python":
    form2["programTypeId"]="31"

b.submit_form(form2)

if b.url[-6:]!="status":
    print("Not status")
    sys.exit(202)

print("Successfully Submitted The Program")
