# @summary
#   This type creates cron jobs to take full-disk backups of virtual machines on a hypervisor using libvirt,
#   then ships them to another machine via SFTP.
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
# @param vm_list
#   Specifies a list of virtual machines to back up.
#
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
