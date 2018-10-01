class minecraft inherits minecraft::params {
  class { 'minecraft::install': } ->
  class { 'minecraft::config': }
# testing branch
}
