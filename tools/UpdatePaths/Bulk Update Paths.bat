@echo off
for %%v in (Scripts/*.txt) do call "%~dp0\..\bootstrap\python" -m UpdatePaths %* Scripts/%%v
pause
