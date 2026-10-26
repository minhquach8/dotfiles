# Personal Settings Recovery

## Purpose

Restore personal workstation behaviour while keeping
private application data outside the public repository.

The dotfiles repository tracks shared configuration.
It does not contain a complete user account backup.

## Raycast

Use the built-in Raycast command:

    Export Settings & Data

Raycast exports a passphrase-encrypted .rayconfig file.

Depending on the current Raycast version, exports may
contain:

- Settings, hotkeys and aliases
- Extensions and window layouts
- Quicklinks and snippets
- Clipboard history
- Notes and AI chats
- Other personal application information

Treat the export as sensitive data.

Never commit the .rayconfig file, its passphrase,
or an unencrypted copy to this repository.

Store the encrypted export in a private backup
location and maintain an off-device copy.

Keep the passphrase in a password manager.

On a replacement Mac:

1. Install Raycast.
2. Import the encrypted configuration.
3. Confirm required extensions and commands.
4. Reconnect accounts and integrations as needed.
5. Verify the Hyper Key and personal shortcuts.
6. Reauthorise macOS permissions as required.

Do not import a backup into the working Raycast
installation merely to test the export. Importing
may change existing settings or data.

Official guidance:

https://manual.raycast.com/import-export/

## Hyper Key

Reference workstation configuration:

- Physical key: Caps Lock
- Modifiers: Control + Option + Shift + Command
- Quick press: Escape

Expected personal shortcuts:

| Command | Shortcut |
|---|---|
| Ghostty | Caps + T |
| Visual Studio Code | Caps + E |
| Firefox | Caps + F |
| Research Project Picker | Caps + P |

These settings must be verified in Raycast itself.

Open Raycast Settings > Keyboard > Hyper Key.

Use its diagnostic panel to investigate conflicts.

Official guidance:

https://manual.raycast.com/hyper-key/

## Script Commands

The Research Project Picker script is version-controlled:

    config/raycast/scripts/research-projects.sh

Deployment target:

    ~/.config/raycast/scripts/research-projects.sh

On a new Mac, verify that Raycast recognises the
Script Commands directory and the command shortcut.

A Raycast export does not replace deployment of
the separately managed script file.

## macOS Privacy Permissions

Review System Settings > Privacy & Security.

Pay attention to:

- Accessibility
- Automation
- Input Monitoring, where required
- Screen & System Audio Recording, where required
- Files & Folders, where required

Grant only the permissions actually needed by
the installed applications.

Do not copy, replace or reset the macOS TCC database
as part of routine recovery.

Do not run blanket permission-reset commands.

## Login and Application Settings

Verify:

- Raycast starts at login if desired
- AeroSpace starts at login
- SketchyBar operates correctly
- JankyBorders operates correctly
- Ghostty opens with the expected configuration
- Display arrangement matches the physical monitors
- Wallpaper assignments are restored

Refer to wallpapers.md and user-guide.md.

## Recovery Status

Verified on the reference Mac:

- Git-managed configuration deployed: 16/16
- Raycast Script Command exists
- Wallpaper assets version-controlled
- Shell commands available in a fresh login shell

Still requiring independent confirmation:

- Fresh encrypted Raycast export
- Off-device backup and passphrase recovery
- Raycast import on a replacement Mac
- macOS privacy permissions on a replacement Mac
- Full clean-machine functional verification

## Security Boundary

Never commit:

- Raycast .rayconfig exports
- Private authentication data
- Password-manager exports
- Session tokens or cookies
- Private application databases

Recovery documentation can be public.
Personal recovery data must remain private.
