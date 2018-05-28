define encrypted_backup::backup_profile_libvirt (
  $server_url,
  $key_auth,
  $gpg_recipient,
  $vm_list,
  $cron_hour,
  $cron_minute,
  $cron_monthday  = '*',
  $cron_month     = '*',
  $cron_weekday   = '*',
) {
  file {"/opt/encrypted_backup/profile_libvirt_${title}.sh":
    ensure   => present,
    mode     => '700',
    content  => epp('encrypted_backup/encrypted_backup_libvirt.epp', {
                server_url     => $server_url,
                key_auth       => $key_auth,
                gpg_recipient  => $gpg_recipient,
                vm_list        => $vm_list,
                }),
  }

  cron { "encrypted_backup_libvirt_${title}":
    command   => "bash -x /opt/encrypted_backup/profile_libvirt_${title}.sh >> /opt/encrypted_backup/profile_libvirt_${title}.log 2>&1",
    user      => 'root',
    hour      => $cron_hour,
    minute    => $cron_minute,
    monthday  => $cron_monthday,
    month     => $cron_month,
    weekday   => $cron_weekday,
  }

}
