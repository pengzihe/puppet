class nginx {
/*	yumrepo { "reposohu":
		descr	=>  "sohu repo",
		baseurl =>  "http://mirrors.sohu.com/centos/6.5/os/x86_64/",
		gpcheck =>  "0",
		enabled =>  "1";
		}
*/
	package {
		"nginx":
		provider =>  "yum",
		ensure   =>  present,
		#ensure  =>  installed,
		#require =>  Yumrepo["reposohu"];
		}
	file { "nginx.conf":
		name    => "/etc/nginx/nginx.conf",
		ensure  => present,
		source  => "puppet:///modules/nginx/nginx.conf",
		mode    => "0644",
		owner   => "root",
		group   => "root",
		require => Package["nginx"],
	}
	
	exec { "webroot":
		command => "/bin/mkdir /web",
		require => File["nginx.conf"],
	}


	file { "index.html":
		name    => "/web/index.html",
                ensure  => present,
                source  => "puppet:///modules/nginx/index.html",
		require => Exec["webroot"],
	}
	service { "nginx":
		ensure      => "running",
		enable      => "true",
		hasrestart  => true,
		hasstatus   => true,
		restart     => "/etc/init.d/nginx restart",
		subscribe   => File["nginx.conf"],
	#	require	    => File["index.html"],
	}	
/*	exec { "startnginx":
		command  => "/etc/init.d/nginx restart",
	}
/*
	file { "index.html":
		name    => "/web/index.html",
                ensure  => present,
                source  => "puppet:///modules/nginx/index.html",
                mode    => "0644",
                owner   => "root",
                group   => "root",
	}
*/
}
