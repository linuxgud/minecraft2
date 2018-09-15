class minecraft::install {
  package { 'java-1.8.0-openjdk-devel': ensure => "1.8.0.181-3.b13.el7_5", }
  package { ['screen', 'js', 'wget']: }
}