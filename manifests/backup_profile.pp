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
  $tar_name       = 'backup.tar.gz',
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
