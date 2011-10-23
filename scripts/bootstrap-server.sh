#!/usr/bin/env bash
BASEDIR="/srv"
CHEFDIR="$BASEDIR/chef-solo"
REPODIR="$CHEFDIR/chef-repo"
COOKDIR="$REPODIR/cookbooks"

function check_deploy_key() {
  if `test ! -f ~/.ssh/id_rsa.pub`; then
    echo "You must install a deploy key into github first!"
    exit 1
  fi
}

function install_chef() {
  PACKAGES="bash-completion vim-gnome build-essential libssl-dev libxml2-dev libxslt1-dev git curl rubygems"
  #sudo locale-gen en_US.UTF-8
  #sudo apt-get update
  #sudo apt-get install -y aptitude
  #sudo aptitude -y safe-upgrade
  #sudo aptitude install -y $PACKAGES
  if [[ ! -f ~/.gemrc ]];then
    cat > ~/.gemrc <<EOF
gem: --no-rdoc --no-ri
EOF
  fi
  which chef-solo > /dev/null 2>&1 || sudo gem install chef
}

function fetch_chef_repo() {
  if `test ! -d $CHEFDIR`;then
    sudo mkdir -p $CHEFDIR
    sudo chown -R deploy:deploy $BASEDIR
    pushd $CHEFDIR
      git clone git@github.com:bramswenson/chef-repo.git $REPODIR
    popd
  fi
}

function configure_chef() {
  if `test ! -f $CHEFDIR/solo.rb`;then
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
  ./generate_node_json.rb
}

function run_chef(){
  sudo chef-solo -c $CHEFDIR/solo.rb -j $CHEFDIR/node.json
}

check_deploy_key
install_chef
fetch_chef_repo
configure_chef
run_chef
