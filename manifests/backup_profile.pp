# @summary
#   This type creates a cron job to backup a given directory, compress and encrypt it, then ship it
#   via SFTP to another machine.
#
# @param backup_dir
#   Specifies the directory to back up.
#
# @param commands_post
#   An arbitrary set of commands to run after the backup job.
#
# @param commands_pre
#   An arbitrary set of commands to run before the backup job.
#
# @param cron_hour
#   The hour to run the cron job.
#
# @param cron_minute
#   The minute to run the cron job.
#
# @param cron_month
#   The month to run the cron job.
#
# @param cron_monthday
#   The day of the month to run the cron job.
#
# @param cron_weekday
#   The day of the week to run the cron job.
#
# @param gpg_recipient
#   The name of the GPG recipient for decryption.
#
# @param key_auth
#   Identifies the filepath on the hypervisor where SFTP key credentials are stored.
#
# @param server_url
#   Ships backups via SFTP to the specified URL.
#
# @param tar_name
#   The filename of the tarball where the backup is stored.
#
# @param temp_dir
#   Specifies the directory where the temporary backup is stored.
#
define encrypted_backup::backup_profile (
  $server_url,
  $key_auth,
  $gpg_recipient,
  $cron_hour,
  $cron_minute,
  $cron_monthday  = '*',
  $cron_month     = '*',
  $cron_weekday   = '*',
  $backup_dir     = "/opt/encrypted_backup/${title}_backup",
  $temp_dir       = "/opt/encrypted_backup/${title}_temp",
  $tar_name       = 'backup.tar',
  $commands_pre   = [],
  $commands_post  = [],
) {
  file {"/opt/encrypted_backup/profile_${title}.sh":
    ensure   => present,
    mode     => '700',
    content  => epp('encrypted_backup/encrypted_backup.epp', {
                server_url     => $server_url,
                key_auth       => $key_auth,
                backup_dir     => $backup_dir,
                temp_dir       => $temp_dir,
                tar_name       => $tar_name,
                gpg_recipient  => $gpg_recipient,
                commands_pre   => $commands_pre,
                commands_post  => $commands_post,
                }),
  }

  file { $backup_dir:
    ensure  => directory,
  }

  file { $temp_dir:
    ensure  => directory,
  }

  cron { "encrypted_backup_${title}":
    command   => "bash -x /opt/encrypted_backup/profile_${title}.sh >> /opt/encrypted_backup/profile_${title}.log 2>&1",
    user      => 'root',
    hour      => $cron_hour,
    minute    => $cron_minute,
    monthday  => $cron_monthday,
    month     => $cron_month,
    weekday   => $cron_weekday,
  }

}
