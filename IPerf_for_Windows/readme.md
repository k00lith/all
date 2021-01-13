# iperf 3.9 for windows

Download all dlls and exe file and store it in folder on windows PC then start exe in cmd line

# Description:
iPerf3 v3.1.3 for Windows comes bundled with a version of Cygwin1.dll (2.5.1) which has a hard-coded TCP window size setting of 278,775.

This causes results to be limited to 12.6Mb/s per thread.
This is why iPerf speeds in Linux are much better that in Windows.

Updating the Cygwin dll to the latest version resolves this issue.
