# Setup Windows development machine from Linux

## Install Windows VM

* `quickget windows 10`
    * (NixOS) `nix-shell -p quickemu`
    * The ISO download will probably fail to download it from the browser with the link quickget gives you
    * Get the link from Opera VPN if microsoft doesn't allow you to download the ISO in your computer
    * Rename the iso in windows-10.conf
    * Run with: `quickemu --vm windows-10.conf`
* Disable 'python marketplace' shortcut from Settings > Manage App Execution Aliases

### File sharing

* Requires samba installed
    * (NixOS) `nix-shell -p samba`
* (NixOS) workaround for old quickemu versions (no /usr/sbin/smbd found)
    * `for f in /nix/store/f18n13k3fm7cqpqnaqf8jv282h9i0q36-samba-4.19.2/bin/*; do sudo ln -s $f /usr/sbin/.; done`
* Run with: `quickemu --vm windows-10.conf --public-dir /plan/2-dev/worklocal/steamworks/`
* Add network location [see quickemu wiki advanced](https://github.com/quickemu-project/quickemu/wiki/05-Advanced-quickemu-configuration#samba)

    > If using a Windows guest, right-click on "This PC", click "Add a network location", and paste this address, removing smb: and replacing forward slashes with backslashes (in this example \\10.0.2.4\qemu)

## SSH Shell

* Inside the windows vm open an admin powershell
* Check and enable the ssh service:
    ```
    Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```
* Start the ssh service:
    ```
    Start-Service sshd
    Get-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic' # start on boot
    ```

## Setup tools

* Install scoop
    ```
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    ```
* Install tools
    ```
    scoop install pipx # extras: git lf pkg-config cwrsync
    # (run next command inside bash)
    for p in meson ninja conan cmake; do pipx install $p; done
    pacman -Ss mingw-w64-clang-x86_64-clang mingw-w64-clang-x86_64-cmake mingw-w64-clang-x86_64-make make rsync bison mingw-w64-clang-x86_64-autotools
    pacman -Ss rsync # convenience

    # Two makes?
    # TODO: decide on ONE pkg manager
    ```
    * git includes *bash* from msys2 which uses mingw64

## Workflow

* Login with: `ssh quickemu@localhost -p 22220` password is `quickemu`
* After login start `clang64`
* Enter shared folder with `cd '\\10.0.2.4\qemu'`
* Sync files with rsycn `sh -c 'cd $HOME && rsync -av //10.0.2.4/qemu/repo-actions/ dev/clones/clone1'` (workaround rsync not supporting windows absolute paths)

# Troubleshoting / Notes

* If suddently you can't type inside the VM try pressing mod keys: Ctrl, Shift, and combinations.
* Why use Scoop over Chocolately? Scoop behaves better for cli contexts:
    * Scoop installs everything in one place, Chocolately doesn't know where a package will end up installed because it just runs arbritrary installers
    * Scoop correctly sets the installed tools in PATH, Chocolately can't do this because of the previous point

## Disable Windows Update

You might want to disable it for reduced resource usage spikes in your host. Just using this VM for dev.

Tried on `Windows 10 22H2 19045.2965`, Extracted from:

- https://gist.github.com/KINGSABRI/70c304e55a588c556b373e4c7a1e32d5
- https://gist.github.com/mikebranstein/7e9169000a6555c195043e1755fbee7e

```
# Disabel Windows update ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" | Disable-ScheduledTask

# Take Windows update  Orchestrator ownership
takeown /F C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator /A /R
icacls C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator /grant Administrators:F /T

# List Windows update  Orchestrator ownership
Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" | Disable-ScheduledTask

# Disable Windows Update Server AutoStartup
Set-Service wuauserv -StartupType Disabled
sc.exe config wuauserv start=disabled 

# Disable Windows Update Running Service
Stop-Service wuauserv 
sc.exe stop wuauserv 

# Check Windows Update Service state
sc.exe query wuauserv | findstr "STATE"

# Double check it's REALLY disabled - Start value should be 0x4
REG.exe QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv /v Start
```

## Some files for the conan patch

vim "C:\Users\Quickemu\pipx\venvs\conan\Lib\site-packages\conans\model\conan_file.py"
vim "C:\Users\Quickemu\pipx\venvs\conan\Lib\site-packages\conans\util\runners.py"
vim 'C:\Users\Quickemu\pipx\venvs\conan\Lib\site-packages\conans\client\subsystems.py'

## Setup MSVC

* Get VS tool: `curl -L -o vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe`

* (optional) Open vs_buildtools.exe and delete all previous instalations, otherwise you'll have to specify a different path (maybe --force could help here?)

* Install MSVC toolchain (cmd.exe): `start /w vs_buildtools.exe --passive --wait --norestart --installPath C:\Users\Quickemu\dev\nana --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.20348` Use --quiet instead of --passive for no GUI.

* Enter cmd dev shell (cmd.exe): `C:\Users\Quickemu\dev\nana\Common7\Tools\VsDevCmd.bat && cmd.exe`
