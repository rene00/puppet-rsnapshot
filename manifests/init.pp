class rsnapshot {

    file { "/root/cron":
        owner => "root", 
        group => "root", 
        mode => 700,
        ensure => directory
    }

    file { "/root/.ssh":
        owner => "root", 
        group => "root", 
        mode => 700,
        ensure => directory
    }

}

class rsnapshot::server inherits rsnapshot {

    package { "rsnapshot":
        ensure => latest,
    }

    file { "/etc/rsnapshot.conf":
        owner => "root", 
        group => "root", 
        mode => 600,
        source => [ 
            "puppet:///files/${fqdn}/etc/rsnapshot.conf",
            "puppet:///files/${hostgroup}/etc/rsnapshot.conf",
            "puppet:///files/${domain}/etc/rsnapshot.conf",
            "puppet:///files/global/rsnapshot/etc/rsnapshot.conf",
        ],
    }

    # ssh config for root
    file { "/root/.ssh/config":
        owner => "root", 
        group => "root", 
        mode => 400,
        source => [ 
            "puppet:///files/${fqdn}/root/.ssh/config",
            "puppet:///files/${hostgroup}/root/.ssh/config",
            "puppet:///files/${domain}/root/.ssh/config",
            "puppet:///files/global/root/.ssh/config",
        ],
        require => File[ "/root/.ssh" ],
    }

    file { "/root/cron/rsnapshot-ssh-key":
        owner => "root", 
        group => "root", 
        mode => 400,
        source => [ 
            "puppet:///files/${fqdn}/root/cron/rsnapshot-ssh-key",
            "puppet:///files/${hostgroup}/root/cron/rsnapshot-ssh-key",
            "puppet:///files/${domain}/root/cron/rsnapshot-ssh-key",
            "puppet:///files/global/root/cron/rsnapshot-ssh-key",
        ],
        require => File[ "/root/.ssh" ]
    }
} 

class rsnapshot::client inherits rsnapshot {

    file { "/root/cron/validate-rsync":
        owner => "root", 
        group => "root", 
        mode => 500,
        source => [
            "puppet:///files/${fqdn}/root/cron/validate-rsync",
            "puppet:///files/${hostgroup}/root/cron/validate-rsync",
            "puppet:///files/${domain}/root/cron/validate-rsync",
            "puppet:///files/global/root/cron/validate-rsync",
        ],
        require => File[ "/root/cron" ]
    }

    file { "/root/.ssh/authorized_keys":
        owner => "root", 
        group => "root", 
        mode => 400,
        source => [
            "puppet:///files/${fqdn}/root/.ssh/authorized_keys",
            "puppet:///files/${hostgroup}/root/.ssh/authorized_keys",
            "puppet:///files/${domain}/root/.ssh/authorized_keys",
            "puppet:///files/global/root/.ssh/authorized_keys",
        ],
        require => File[ "/root/.ssh" ]
    }

}
