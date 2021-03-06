#!/bin/bash

echo -e "---\n:rubygems_api_key: $GEM_API_KEY" > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

cd lf-git
build_version=$(ruby -r ./lib/license_finder/version.rb -e "puts LicenseFinder::VERSION")
built_gem="pkg/license_finder-$build_version.gem"

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME

mkdir ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts

if [ -z "$(gem fetch license_finder -v $build_version 2>&1 | grep ERROR)" ]; then
  echo "LicenseFinder-$build_version already exists on Rubygems"
  exit 0
fi

rake release
