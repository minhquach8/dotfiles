# SSH — Remote Research Access
<!-- search: ssh remote server login key authentication config known_hosts scp connection timeout debugging secure -->

Use SSH for secure remote shell access.
The commands below use documentation-only hostnames.

## Connect to a server

| Command | Description |
| --- | --- |
| `ssh username@server.example.com` | Connect using SSH |
| `ssh -p 2222 username@server.example.com` | Connect using a custom port |
| `ssh -o ConnectTimeout=10 username@server.example.com` | Set a connection timeout |
| `ssh -V` | Display OpenSSH version |

Replace the example hostname and username with the
approved details for your own server.

Never embed production passwords or private keys
in scripts or documentation.

## SSH client configuration

The user-local configuration file is:

~~text
~/.ssh/config
~~

Illustrative entry:

~~sshconfig
Host research-server
    HostName server.example.com
    User username
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
~~

Once configured, connect with:

~~bash
ssh research-server
~~

This does not require sudo.

## Inspect SSH configuration

| Command | Description |
| --- | --- |
| `ssh -G research-server` | Display effective SSH configuration |
| `ssh -v research-server` | Enable basic connection diagnostics |
| `ssh-keygen -lf ~/.ssh/id_ed25519.pub` | Inspect a public-key fingerprint |

The commands above assume the example host alias and
public-key file exist.

SSH debug output can reveal hostnames, usernames and
paths. Review it before sharing logs.

## File transfers

| Command | Description |
| --- | --- |
| `scp local-file.txt research-server:~/` | Copy a local file to the remote home directory |
| `scp research-server:~/remote-file.txt .` | Copy a remote file into the current directory |

Verify destination paths before transferring.
File transfers can replace existing destination files.

## Connection troubleshooting

A connection timeout may indicate a network, firewall
or routing problem.

A permission-denied message may indicate an incorrect
username, missing authorised key or authentication
policy.

A host-key warning requires verification of the
server's identity before changing known-host entries.

Never disable host-key verification merely to silence
a warning.

On a shared research server, avoid restarting SSH
services or changing global SSH settings without
administrator approval.
