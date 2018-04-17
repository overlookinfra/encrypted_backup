class encrypted_backup {
  file {'/opt/encrypted_backup':
    ensure  => directory,
  }
}
