@echo off
copy nul pipe1.txt >nul
copy nul pipe2.txt >nul

.\Project2.exe -m step -p white <pipe1.txt >>pipe2.txt | .\Project2.exe -m step -p black <pipe2.txt >>pipe1.txt

del pipe1.txt pipe2.txt

exit /b