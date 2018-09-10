class minecraft::install {
  package { 'java-1.8.0-openjdk-devel': ensure => "1.8.0.161-0.b14.el7_4", }

  package { ['screen', 'js', 'wget']: }

}