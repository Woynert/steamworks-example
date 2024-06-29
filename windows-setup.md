# Windows Setup

Develop on Linux using a Windows VM, it also works for native windows, just skip this "Setup Host" section.

## Setup Host

### Install Windows VM

* `quickget windows 10`
    * (NixOS) `nix-shell -p quickemu`
    * The ISO download will probably fail to download because Microsoft bans your IP for using CLI, so download on the browser using a VPN (like Opera VPN)
    * Place the iso and rename it in windows-10.conf
    * Test with: `quickemu --vm windows-10.conf`
* Disable "python marketplace" shortcut from Settings > Manage App Execution Aliases

### File sharing

* Requires samba installed. NixOS: `nix-shell -p samba`
    * (Only NixOS) workaround for old quickemu versions (no /usr/sbin/smbd found)
        `for f in /nix/store/f18n13k3fm7cqpqnaqf8jv282h9i0q36-samba-4.19.2/bin/*; do sudo ln -s $f /usr/sbin/.; done`
* Test with: `quickemu --vm windows-10.conf --public-dir /plan/2-dev/worklocal/steamworks/`
* Add network location [see quickemu wiki advanced](https://github.com/quickemu-project/quickemu/wiki/05-Advanced-quickemu-configuration#samba)

    > If using a Windows guest, right-click on "This PC", click "Add a network location", and paste this address, removing smb: and replacing forward slashes with backslashes (in this example \\10.0.2.4\qemu)

### SSH Shell

* Inside the Windows VM open an admin Powershell
* Check and enable the SSH service:
    ```
    Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```
* Start the SSH service:
    ```
    Start-Service sshd
    Get-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic' # start on boot
    ```

## Setup Development Environment

### CLI tools

* Install scoop
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    ```
* Install tools
    ```cmd
    scoop install git python pipx pkg-config make # extras: lf cwrsync
    ```
    ```bash
    for p in meson ninja conan cmake; do pipx install $p; done
    ```
    * git includes *bash* from msys2 which uses mingw64
    * If "C:\Users\Quickemu\.local\bin" is not on your PATH. Run `pipx ensurepath` to update.

### MSVC Compiler

* Get VS tool: `curl -L -o vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe`

* (optional) Open vs_buildtools.exe and delete all previous instalations, otherwise you'll have to specify a different path (maybe --force could help here?)

* Install MSVC toolchain (cmd.exe): `start /w vs_buildtools.exe --passive --wait --norestart --installPath C:\Users\Quickemu\dev\msvc --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.20348` Use --quiet instead of --passive for no GUI. Be mindful that this tool is very slow, it might hang for a while without using resources before exitting. [See Microsoft workaround for containers.](https://learn.microsoft.com/en-us/visualstudio/install/build-tools-container)

* Enter cmd dev shell
    * (cmd.exe): `C:\Users\Quickemu\dev\msvc\Common7\Tools\VsDevCmd.bat -arch=amd64 && cmd.exe`
    * (bash): `cmd.exe '\/C' 'C:\Users\Quickemu\dev\msvc\Common7\Tools\VsDevCmd.bat -arch=amd64 && cmd.exe'`

## Workflow

* Start VM with file sharing: `quickemu --vm windows-10.conf --public-dir /plan/2-dev/worklocal/steamworks/`
* Login with: `ssh quickemu@localhost -p 22220` password `quickemu`
* Start bash `bash`
* Sync source files with rsync
    * (cmd.exe) `sh -c 'cd $HOME && rsync -av //10.0.2.4/qemu/repo-actions/ dev/clones/clone1'` (workaround rsync not supporting windows absolute paths)
    * (bash) `sh -c 'cd $HOME && rsync -av //10.0.2.4/qemu/repo-actions/{.*,*} dev/clones/clone1/'`
* Edit source on linux, sync on windows, compile/run

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

Run on Powershell:

```powershell
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

## MinGW (WIP)

For MinGW to be able to compile libiconv conan must be patched: [add proper patch]

```
# C:\Users\Quickemu\pipx\venvs\conan\Lib\site-packages\conans\client\subsystems.py@53
if active and python_will_run_bash:
    wrapped_cmd = environment_wrap_command(envfiles, envfiles_folder, command)
```

