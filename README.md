# Encrypted Backup

> This module is maintained by Puppet for internal purposes, and we have no plans for future feature development. It does not qualify for Puppet Support plans.
>
> [tier:maintenance-mode]

## Table of Contents

1. [Description](#description)
2. [Setup](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Description

The `encrypted_backup` module provides a simple way to securely back up Linux machines and ship backups elswhere. It encrypts data using GPG and transfers data via SFTP, making the backups jobs secure end-to-end.

This module relies on many fundamental *nix tools, such as cron, tar, and SSH, eliminating complexity and making this module lightweight and portable.

## Setup

Prior to using this module, you will need to set up a GPG keychain on the backup server to properly encrypt data.

**Note:** `encrypted_backup` manages backup jobs with cron. As a result, we strongly recommend that you purge unmanaged cron jobs with Puppet. If you don't purge unmanaged cron jobs, older backup jobs will persist even after removing Puppet code.

You can purge unmanaged cron jobs by including something like the following in your Puppet code:

```puppet
resources { 'cron':
  purge => true,
}
```

## Usage

You can back up a given directory with the `backup_profile` defined type:

```puppet
encrypted_backup::backup_profile { 'nginx':
  backup_dir    => '/etc/nginx',
  gpg_recipient => 'backup-admin@example.com',
  key_auth      => '/var/lib/backup/.ssh/id_rsa',
  server_url    => 'nginx@backups.example.com:nginx/',
}
```

The `backup_profile_libvirt` defined type allows you to take full-disk backups of a virtual machine from a hypervisor.

```puppet
encrypted_backup::backup_profile_libvirt { 'hypervisor':
  gpg_recipient => 'backup-admin@example.com',
  key_auth      => '/var/lib/backup/.ssh/id_rsa',
  server_url    => 'hypervisor@backups.example.com:hypervisor/',
  vm_list       => [ 'web.example.com', 'db.example.com' ],
}
```

## Limitations

This module has only been tested on Ubuntu 16.04 machines.
