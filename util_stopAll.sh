docker kill $(docker ps -q)

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    taskkill //f //im ssh.exe
    taskkill //f //im plink.exe
else
    pkill -f ssh
    pkill -f plink
fi
