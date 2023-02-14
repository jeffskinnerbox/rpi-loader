<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      1.5.0
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


-----

* [How to Use Tags in Ansible Playbook (Examples)](https://www.linuxtechi.com/how-to-use-tags-in-ansible-playbook/)


* [How To Use Rsync to Sync Local and Remote Directories](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories)








# Background
I plan to use a Synology [DiskStation DS220+][38] small office NAS
to perfrom hourly backup of my Linux desktop system.
To create these backups,
I plan to use a combination of `rsync` and `rsnapshot`,
have the backup process be controlled via the source machine,
and automate the backup process via `cron`.
Essentially, I'm pushing the backups from what will be, in time,
multiple sources to a single destination.

The downside of this approach is that I have multiple sources to touch if I wish to adjest my backups.
In the past, I have used a pull approach
(where the storage destination controls the backup process),
but I found this

## Enable Key Based SSH Authentication
For this to work autonomously and work over the entire filesystem,
this backup process must run with root privileges and it must use SSH authentication
(to avoid a password prompt).

Making this happen proved to be a challenge.
I created a special user on the Synology NAS (`backup_user`) to "receive" the backup,
and as such, this user needs SSH key-based authentication.
My efforts to configure my Synology NAS SSH to using SSH key-based authentication,
but this seemed not to be supported by default.
I did the normal setup, where the "local machine" (aka source machine)
is to login to the "remote machine" (aka destination machine being the Synology NAS):

* Assure the SSH daemon has Public Key Authentication enabled on the remote machine
* Create a SSH public key on your local machine
* Make sure the local machine public key is placed in the remote machines `~/.ssh/authorized_keys` file

Despite doing the above, I kept getting the request for a password.
After some Web searching,
I found that Synology went the extra-mile to lockdown their product
and there are several places where you can get blocked establishing passwordless access.
The solution can be found amount the sources below
and my installation processes takes care of things.

>**NOTE:** One of the confusing challegs was the fact that
>after Synology DSM 6.2.2-24922, it appears that
>[any user not in the >"administrators" group cannot log in remotely via SSH anymore][01].
>To get this to work, I had to give the `backup_user` administrative permissions
>(via adding `backup_user to the `administrators` group).
>Without this, I was prompted to provide a password.
>So unlike previous implementation of this design,
>there is no need to provide `backup_user` `sudo` access to `rsync` and `rsnapshot`.

## Fix Desktop Backup Tools
Rsync should already be installed on most Linux system but
you should also install the [grsync][04] & [rsnapshot][08] tools,
using this command `sudo apt-get install rsync grsync rsnapshot`.
But there is a problem.
The tool [`rsnapshot` has been removed from Raspberry Pi OS version of Debian][51]
due to lack of a person to support it.
Hopefully this will be corrected in time but I need a solution now.
Luckly, I found the Github site for the `rsnapshot` sources code,
and I can install it from the source I found on [Github for the `rsnapshot.org` website][52].
Following the instructions on Github,
I install it under the `backup_user` login on the `test-pi` server.

## Sources
The original source for this work was the tool I wrote several years ago,
["Network Backups via Rsync and Rsnapshot"][02].
With this version, I push (instant of pulled) files to the disks storing the backups,
I had to install source code for `rsnapshot` for Raspberry Pi OS,
and had to make special provisions for Synology's use of SSH,
and this time I'm using a network attached storage instead of a USB drive
(giving me higher reliability).
Theses sources helped in making these changes.

* [How To Use Rsync to Sync Local and Remote Directories](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories)
* [How To Configure SSH Key-Based Authentication on a Linux Server](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
* [Log in with ssh key authorization on a Synology NAS](https://samuelsson.dev/log-in-with-ssh-key-authorization-on-a-synology-nas/)
* [Configure Synology NAS SSH Key-based authentication](https://blog.aaronlenoir.com/2018/05/06/ssh-into-synology-nas-with-ssh-key/)
* [How to enable SSH key authentication on Synology NAS](https://community.synology.com/enu/forum/1/post/136213)
* [Enable Key Based SSH Authentication For Synology Servers](https://www.youtube.com/watch?v=XN9SuzV08Ew)
* [How I configured my Synology NAS and Linux to use rsync for backups](https://obsolete29.com/posts/2022/04/30/how-i-configured-my-synology-nas-and-linux-to-use-rsync-for-backups/)
* [How do I back up data from a Linux device to my Synology NAS via rsync?](https://kb.synology.com/en-global/DSM/tutorial/How_to_back_up_Linux_computer_to_Synology_NAS)
* [Backup and Restore Your Linux System with rsync](https://averagelinuxuser.com/backup-and-restore-your-linux-system-with-rsync/)


------


# Create Backup User on Local Machine (`test-pi`)
There is an Ansible Playbook for this.

#### Step 1: Create Backup User and Validate - DONE
On the Linux desktop, you need to assure there is a `backup_user` login,
with a UID of less that 500,
which will run the rsync / rsnapshot utilities
and have `ssh` authentication keys.

>**NOTE:** I choose a UID of 400 so that the `backup_user`
>would not appear on the Ubuntu/Debian login screen list.
>To hide a user from the Ubuntu/Debian login screen list,
>you should be able to add the name to the hidden-users
>list in the file `/etc/lightdm/users.conf`, but there is a [problem][45].
>The is an alternative, and that is to choose a UID value less than 500
>(See the "minimum-uid" in `/etc/lightdm/users.conf`).

```bash
# validate that backup_user login exist with uid of 400
cat /etc/passwd | grep backup_user

# validate that backup_user has a home directory with required tools
ls -a /home/backup_user/
```

#### Step 2: Add backup_user to sudo List - DONE
The `backup_user` is not root, and therefore, the utilities it uses for backups
(`rsync` and `rsnapshot`)
can't freely move through the whole directory system , write files, and such.
Again using the [`visudo`][43] command,
edit the [`/etc/sudoers`][44] file by adding the following
to the bottom of the file.

```bash
# start the edit process and do the edits below
sudo visudo /etc/sudoers

# allows this user to not need a password to sudo the specified command(s)
backup_user    ALL=NOPASSWD:    /usr/bin/rsync
backup_user    ALL=NOPASSWD:    /usr/bin/rsnapshot
```

Now check your work:

```bash
# check if your edits took hold
$ sudo cat /etc/sudoers | grep backup_user
backup_user    ALL=NOPASSWD:    /usr/bin/rsync
backup_user    ALL=NOPASSWD:    /usr/bin/rsnapshot
```

A [better approach][50] might be to put the access rules for the backup account in a single file.
In this case, put the rules below in a file call `backup_user` in a directory `/etc/sudoers.d/`.

```bash
# allows this user to not need a password to sudo the specified command(s)
backup_user    ALL=NOPASSWD:    /usr/bin/rsync
backup_user    ALL=NOPASSWD:    /usr/bin/rsnapshot
```

>**NOTE:** Why is there this `/etc/sudoers.d/` directory?
>Changes made to files in `/etc/sudoers.d` remain in place if you upgrade the system.
>This can prevent user lockouts when the system is upgraded.
>Ubuntu/Debian tends to like this behavior.
>Other distributions are using this layout as well.

#### Step 3: Increased Security of backup_user Account - DONE
The final step is to lock all this down.
To increase the security of the overall scheme,
on the remote systems and on the local system,
remove the user password from the `backup_user`
and set the shell to a NOOP command.

```bash
# increase security by deleting password and remove login shell
sudo passwd --delete backup_user
sudo usermod -s /sbin/nologin backup_user
```


------


# Create backup_user Account on Remote Machine (Synology NAS)
This is done manually on he Synology NAS.

#### Step 1: Create `backup_user` on Synology NAS - DONE
Create a user account for the backup process,
which I called `backup_user`.
Do this via the Synology DSM Web interface:

* **Control Panel** > **Terminal & SNMP** > **Enable SSH service** is checked
* **Control Panel** > **User & Group** create the `baskup_user` user.
Make sure to request a home directory is also provisioned.
Verify "users" and "administrators" are checked (only Admins can ssh)
* Restart the `sshd` daemon by disabling and re-enabling it in the Synology's Web interface

Login to the Synology NAS and
create the targeted user account's along with a home directory for it.

```bash
#login into the sysnology nas
ssh backup_user@192.168.1.201

# make a directory to store the ssh keys
cd ~
mkdir .ssh
touch .ssh/authorized_keys
chmod 700 .
chmod 700 .ssh
chmod 600 .ssh/authorized_keys

# edit the /etc/ssh/sshd_config file and make these changes
#      remove the commenting "#" before "PubkeyAuthentication yes"
#      remove the commenting "#" before "AuthorizedKeysFile .ssh/authorized_keys"
#      remove the commenting "#" before "ChallengeResponseAuthentication no"
sudo vim /etc/ssh/sshd_config
```

Now you must restart the `sshd` daemon:

* Enter **Control Panel** > **Terminal & SNMP**
* Restart the `sshd` daemon by disabling and re-enabling SSH services


-------


# Create Authentication Keys for backup_user
There is an Ansible Playbook for this.

#### Step 1: Prepare the Local Machine (`test-pi`) - DONE
On the device you will be using to access the Synology NAS,
I call the "local machine" (aka `test-pi`),
you need to create a new pair of public & private keys.
This must be done for the user account you plan to use to login into the "remote machine".

On the local machine (aka `test-pi`):

```bash
R$Ke9KweR09 - synology/backup_user
8KQT!x28imwqy94 - synology/admin-jeff

# log into the local machines user account that needs access
# using 'su --shell' since the acount was create without a login shell
sudo su --shell=/bin/bash backup_user

# changes users home directory permissions to drwx------
chmod 700 ~

# generate a 4096 bit ssh key of type rsa
ssh-keygen -t rsa -b 4096 -C "This key is for rsync/rsnapshot/duplicati backups to Synology NAS."

# publish the public key to remote machines (sysnology nas) backup_user
ssh-copy-id backup_user@192.168.1.201
```

If all has gone as expected, you should be able to login to the Synology NAS using
`ssh` without supplying a password.
Check with:

```bash
# from 'pi' user account on 'test-pi', this will prompt for a password
# from 'backup_user' user account on 'test-pi', gain access without password
ssh backup_user@192.168.1.201
```

#### Step 2: Basic Test Run of rsync - DONE
Now we'll do a test run to make sure `rsync`, executed on `test-pi`,
can move files from `test-pi` to the Synology NAS.
This should be done without a password prompt for the `backup_user` account.
Make sure you have created the folder on the Synology NAS to recieve the files.

```bash
R$Ke9KweR09 - synology/backup_user
8KQT!x28imwqy94 - synology/admin-jeff

# login to the 'backup_user' acount
sudo su --shell=/bin/bash backup_user

# while logged-in as 'backup_user' on test-pi
# using the 'backup_user' account, test rsync for remote backup - with password prompt
sudo rsync -azv --dry-run /home backup_user@192.168.1.201:/volume1/NetBackup/test-pi/1st-test
```

Basically, the three options on `rsync` mean to preserve all the attributes of your files.
Owner attributes or permissions will not be modified during the backup process.

* **-rlptgoD** - recurse into directories, copy symlinks as symlinks, preserve permissions, preserve modification times, preserve group, preserve owner (super-user only), preserve device files (super-user only), preserve special files
* **--archive, -a** - archive mode is equavlent to `-rlptgoD` (you can't use -A,-X,-U,-N,-H)
* **--compress, -z** - compress file data during the transfer
* **--verbose, -v** - increase verbosity
* **--dry-run** - This option simulates the backup. Useful to test its execution.
* **--delete** - this option allows you to make an incremental backup. That means, if it is not your first backup, it will backup only the difference between your source and the destination. So, it will backup only new files and modified files and it will also delete all the files in the backup which were deleted on your system. **Be careful with this option.**

Source:

* [Backup and Restore Your Linux System with rsync](https://averagelinuxuser.com/backup-and-restore-your-linux-system-with-rsync/)


-----


# Create Rsnapshot Automation for Backups
There is an Ansible Playbook for this.

To get your backup work again,
you should read the document
`/home/jeff/blogging/content/articles/network-backups-via-rsync-and-rsnapshot.md`.
The steps you need to perform, using the documentation as your guide:

1. Complete all the tasks documentated above.
2. Install all the files and scripts to enable the automation.
3. Do your first backup manually (i.e. `sudo rsnapshot hourly`).
4. To get automated backups running, update the `crontab` file for the user `backup_user`, and restart it.

Our mission here is to use rsnapshot to create backups of both normal
and protected/restricted files from one server to another over `ssh`
without enabling remote root access to either server while
maintaining original file attributes and permissions.

>**NOTE:** To automate rsnapshot backup to a remote servers,
>you'll also need to set up key-based authentication over SSH on the remote
>machines that you want to backup,
>so that they can be accessed without need for a password login.
>And you need to make sure this arrangement survives a reboot.
>To accomplish this, you will need to create an SSH public
>and private keys to authenticate on the rsnapshot server.
>This was all discussed earlier.

Where rsync does the actual file backups,
`rsnapshot` is responsible for the overall management of the backups.
In my case, I want it to schedule a nested and rotating series of incremental backups for my systems.
I want the schedule and the backup increments to be:

* Every 4 hours, create an incremental backup, and store all of them for the past 24 hours
* Create a daily incremental backups (from the last hourly backup), and store a daily backup for the past 7 days
* Create a weekly incremental backups, and store them for the past 4 weeks
* Create monthly incremental backups, and store for the past 3 months

When making the backups, the contents of `/dev`, `/proc`, `/sys`, `/tmp`, and `/run` should be excluded
because they are populated at boot (while the directories themselves are not created).
The file `/lost+found` is filesystem-specific and doesn't need to be copied.

>**NOTE:** If you plan on backing up your system onto itself, say `/mnt` or `/media`,
>don't forget to add it to the exclude list, to avoid an infinite loop.

`rsnapshot` also provides a non-command-line method for excluding file, which is what I'm using.
Specifically, I have defined exclusion files for Ubuntu Linux, Raspberry Pi OS, and Windows based systems.
For Raspberry Pi OS, the file is called `rsync-exclude-RPi` and look something like this:

```
- /var/lib/pacman/sync/*
- /home/pi/Dropbox
- /lost+found
- /media/*
- /cdrom/*
- /proc/*
- /mnt/*
- /run/*
- /tmp/*
- /sys/*
- /dev/*
```

#### Step 1: Test Run of Exclude Files from rsync - DONE
In a typical backup situation,
you might want to exclude one or more files (or directories) from the backup.
You might also want to exclude a specific file type from rsync.
Let's run a backup of `/home/pi/`
but leave out the `tmp` and `src` directories.

```bash
R$Ke9KweR09 - synology/backup_user
8KQT!x28imwqy94 - synology/admin-jeff

# login to the 'backup_user' acount
sudo su --shell=/bin/bash backup_user

# while logged-in as 'backup_user' on test-pi
# using the 'backup_user' account, test rsync for remote backup - with password prompt
sudo rsync -azv --dry-run -e ssh --exclude 'tmp' --exclude 'src' /home/pi backup_user@192.168.1.201:/volume1/NetBackup/test-pi/2nd-test
```

You could also create a file that contains the exclude list `tmp` and `src`.
This would look like:

```bash
sudo rsync -azv --dry-run --exclude-from 'exclude-list.txt' /home/pi backup_user@192.168.1.201:/volume1/NetBackup/test-pi/2nd-test
```

#### Step X:
To implement the above backup rules (and many others),
you need to edit a configuration file located at `/etc/rsnapshot.conf`.
**Note: This file must only have tabs between arguments. No spaces.**
(It's a quirk of `rsnapshot` that it requires tabs.)

>**NOTE:** The configuration file requires tabs between elements
>and all directories require a trailing slash.
>Just open the configuration file using a text editor such as `vi` or `gedit` but be careful.
>Many editors are set to convert any tabs entered by the user to spaces.
>This can be a source of great confusion and frustration!

The configuration elements I edited are below
(`/usr/share/doc/rsnapshot/examples/rsnapshot.conf.default.gz`
can be used as a starting point):

```bash
# location where backups will be stored
snapshot_root	/mnt/backup/

# rsync command executed on the remote system
cmd_rsync	/usr/bin/rsync

# incremental backup rules
retain		hourly	6
retain		daily	7
retain		weekly	4
retain		monthly	3

# rsnapshot's log file
logfile	/var/log/rsnapshot.log

# All rsync commands have at least these options set.
rsync_short_args	-aev
rsync_long_args	--delete --numeric-ids --relative --delete-excluded

# ssh args passed
ssh_args	-i /home/backup_user/.ssh/id_rsa

# systems to be backed up, what high level directory name is to be used
# and the additional arguments to pass to rsync
backup	/	desktop/	exclude_file=/home/backup_user/rsync-exclude-desktop
backup	backup_user@RedRPi:/	RedRPi/	exclude_file=/home/backup_user/rsync-exclude-RPi,+rsync_long_args=--rsync-path=/home/backup_user/bin/rsync-wrapper.sh
backup	backup_user@BlackRPi:/	BlackRPi/	exclude_file=/home/backup_user/rsync-exclude-RPi,+rsync_long_args=--rsync-path=/home/backup_user/bin/rsync-wrapper.sh
backup	Sara@SaraPC:/	SaraPC/	exclude_file=/home/backup_user/rsync-exclude-windows,+rsync_long_args=--fake-super
```

In my backup scheme, I have several remote systems (i.e. desktop, test-pi, home-assistant, etc.),
and a backup server itself (i.e. Synology NAS).
All system will use a common user called `backup_user`,
who's only purpose is to support the backup process.
From the backup system, we'll be able to logon to each remote system using
the `backup_user` ssh public key.
The main trick is to set sudoers on the remote system such that it allow `rsync`
root access to `backup_user`,
and it tell rsnapshot to use additional parameters when calling `rsync`.
This all required to maintain the security of the remote systems,
and was discussed in the text above.








-----






[01]:https://community.synology.com/enu/forum/1/post/125859
[02]:https://github.com/jeffskinnerbox/jeffskinnerbox.github.io/blob/master/content/articles/network-backups-via-rsync-and-rsnapshot.md

[04]:http://www.opbyte.it/grsync/
[08]:http://www.rsnapshot.org/

[38]:https://www.synology.com/en-us/products/DS220+

[43]:http://www.sudo.ws/sudo/sudoers.man.html
[44]:http://www.sudo.ws/visudo.man.html
[45]:http://www.cyberciti.biz/faq/howto-change-rename-user-name-id/

[50]:https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file
[51]:https://github.com/rsnapshot/rsnapshot/issues/279
[52]:https://github.com/rsnapshot/rsnapshot
[53]:
[54]:
[55]:
[56]:
[57]:
[58]:
[59]:
[60]:

