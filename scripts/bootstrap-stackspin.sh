#!/usr/bin/env bash
RUBY='1.9.2-p290'
RUBY_PREFIX='/usr/local'
#USER='stackspin'
BASEDIR="/srv/stackspin"
SRCDIR="$BASEDIR/src"
CHEFDIR="$BASEDIR/chef-solo"
REPODIR="$CHEFDIR/chef-repo"
COOKDIR="$REPODIR/cookbooks"

function create_dir() {
  if `test ! -d $1`; then
    echo "Creating dir $1"
    mkdir $1
    #sudo chown -R $USER:$USER $1
  fi
}

function check_deploy_key() {
  if `test ! -f ~/.ssh/id_rsa.pub`; then
    echo "You must install a deploy key into github first!"
    exit 1
  fi
}

function install_deps() {
  PACKAGES="bash-completion vim-gnome build-essential libssl-dev libxml2-dev libxslt1-dev git curl libreadline-dev libcurl4-openssl-dev zlib1g-dev"
  sudo locale-gen en_US.UTF-8
  sudo apt-get update
  sudo apt-get install -y aptitude
  sudo aptitude -y safe-upgrade
  sudo aptitude install -y $PACKAGES
}

function fetch_repo() {
  local repo=$1
  local target=$2
  if `test ! -d $target`;then
    echo "cloning $repo to $target"
    git clone $repo $target
  fi
}

function install_ruby_build() {
  if [[ "$(which ruby-build)" == "" ]]; then
    fetch_repo https://github.com/sstephenson/ruby-build.git $SRCDIR/ruby-build
    echo "Installing ruby-build"
    pushd $SRCDIR/ruby-build
      sudo ./install.sh
    popd
  fi
}

function install_ruby() {
  if [[ "$(which ruby)" == "" ]]; then
    echo "Installing ruby $RUBY to $RUBY_PREFIX"
    sudo $(which ruby-build) $RUBY $RUBY_PREFIX
  fi
  if [[ ! -f ~/.gemrc ]];then
    echo "Installing gemrc"
    cat > ~/.gemrc <<EOF
gem: --no-rdoc --no-ri
EOF
  fi
}

function fetch_chef_repo() {
  fetch_repo https://github.com/bramswenson/chef-repo.git $REPODIR
}

function install_chef() {
  if ! `which chef-solo > /dev/null 2>&1`;then
    sudo gem install chef
  fi
}

function configure_chef() {
  if `test ! -f $CHEFDIR/solo.rb`;then
    echo "Creating chef config"
    cat > $CHEFDIR/solo.rb <<EOD
file_cache_path '$CHEFDIR/cache'
file_backup_path '$CHEFDIR/backup'
cookbook_path '$COOKDIR'
data_bag_path '$CHEFDIR/data_bags'
log_level :info
log_location '$CHEFDIR/chef-solo.log'
verbose_logging true
solo true
EOD
  fi
  if `test ! -f ./generate_node_json.rb`; then
    echo "Fetching generate_node_json.rb"
    curl https://raw.github.com/bramswenson/chef-repo/master/scripts/generate_node_json.rb > ./generate_node_json.rb
  fi
  chmod +x ./generate_node_json.rb
  ./generate_node_json.rb
}

function run_chef(){
  echo 'alias rchef="sudo chef-solo -c /srv/stackspin/chef-solo/solo.rb -j /srv/stackspin/chef-solo/node.json"' >> .bashrc
  sudo chef-solo -c /srv/stackspin/chef-solo/solo.rb -j /srv/stackspin/chef-solo/node.json
}

create_dir $BASEDIR
create_dir $CHEFDIR
check_deploy_key
install_deps
install_ruby_build
install_ruby
fetch_chef_repo
install_chef
configure_chef
run_chef
