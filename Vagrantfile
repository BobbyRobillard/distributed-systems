# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.provision "shell", inline: $shell
end

$shell = <<-'CONTENTS'
  apt-get update
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
  apt-get update
  apt-get install -y esl-erlang
  apt-get install -y elixir
  apt install -y openssl
CONTENTS

###############
# Custom File #
###############

# 2018.10.24-DEA
