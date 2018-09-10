define minecraft::instance ($version, $eula='true', $port, $state='stopped', $xms='512M', $xmx='1024M') {
  $instance_name = $name
  $download = $version ? {
    'latest' => "${::minecraft_latest_version}",
    default  => "${version}"
  }

  exec { "download_minecraft_for_${instance_name}":
#    command => "/usr/bin/wget -q -O minecraft_server.${download}.jar https://s3.amazonaws.com/Minecraft.Download/versions/${download}/minecraft_server.${download}.jar",
    command => "/usr/bin/wget -q -O minecraft_server.${download}.jar $(/srv/minecraft/get-minecraft-download-url.sh ${download})",
    cwd     => '/srv/minecraft',
    creates => "/srv/minecraft/minecraft_server.${download}.jar",
    
    timeout => 600
  }

  user { "$instance_name":
    managehome => true,
    password   => '!!',
    home       => "/srv/minecraft/$instance_name",
    require    => File['/srv/minecraft'],
  }

  file { "/srv/minecraft/${instance_name}/minecraft_server.jar":
    ensure  => link,
    target  => "/srv/minecraft/minecraft_server.${download}.jar",
    require => User["$instance_name"],
  }

  file {
    default:
      require => User["$instance_name"],
      ensure  => present,
      owner   => $instance_name,
      group   => $instance_name;

    "/srv/minecraft/${instance_name}/systemd.conf":
      before => Augeas["systemd.conf_for_${instance_name}"];

    "/srv/minecraft/${instance_name}/eula.txt":
      before => Augeas["eula.txt_for_${instance_name}"];

    "/srv/minecraft/${instance_name}/server.properties":
      before => Augeas["server.properties_for_${instance_name}"];
  }

  augeas {
    default:
      lens => 'Properties.lns';

    "systemd.conf_for_${instance_name}":
      require => File["/srv/minecraft/${instance_name}/systemd.conf"],
      incl    => "/srv/minecraft/${instance_name}/systemd.conf",
      changes => ["set \"XMS\" \"${xms}\"","set \"XMX\" \"${xmx}\""];

    "eula.txt_for_${instance_name}":
      require => File["/srv/minecraft/${instance_name}/eula.txt"],
      incl    => "/srv/minecraft/${instance_name}/eula.txt",
      changes => "set \"eula\" \"${eula}\"";

    "server.properties_for_${instance_name}":
      require => File["/srv/minecraft/${instance_name}/server.properties"],
      incl    => "/srv/minecraft/${instance_name}/server.properties",
      changes => "set \"server-port\" \"${port}\"",
      notify  => Service["minecraft@${instance_name}"];
  }

  service { "minecraft@${instance_name}":
    ensure => "${state}",
    enable => true,
    require => Augeas["server.properties_for_${instance_name}","eula.txt_for_${instance_name}"]
  }

}