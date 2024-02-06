#!/bin/sh

ls /usr/lib/glib-2.0

set -x

FILES=$(find ./Source/ThirdParty -type l);

for file in ${FILES}
do
        cp ${file} temp
        mv temp ${file}
done

id -u
id -g

ue_plugin_build_script="/home/ue4/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh"
ue_plugin_build_script_args="BuildPlugin -plugin=/github/workspace/ReadyCodeUE.uplugin -Package=/github/workspace/Package -TargetPlatforms=Linux -NoDeleteHostProject"
sudo "$ue_plugin_build_script" $ue_plugin_build_script_args

sudo chown -R 1000:1000 ./Package
sudo chmod 775 ./Package
sudo chmod g+s ./Package

sudo mkdir /home/.config
sudo mkdir /home/.config/Epic

sudo chown -R 1000:1000 /github/home/.config/Epic
sudo chmod 775 /github/home/.config/Epic
sudo chmod g+s /github/home/.config/Epic

ls -la /home/.config/Epic

ue_run_test_script="/home/ue4/UnrealEngine/Engine/Binaries/Linux/UnrealEditor"
ue_run_test_script_args="\"/github/workspace/Package/HostProject/HostProject.uproject\" -game -buildmachine -stdout -unattended -nopause -nullrhi -nosplash -ExecCmds=\"automation Run RunAll;quit\" -TestExit=\"Automation Test Queue Empty\" -ReportExportPath=\"./\" -Log -Log=tests.log"
"$ue_run_test_script" $ue_run_test_script_args
