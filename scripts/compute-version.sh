#!/bin/bash

source $(dirname $(realpath "$0"))/base/base.sh
source $(dirname $(realpath "$0"))/get-version.sh

relevantTags=("major" "minor" "patch" "iteration")
maxMajorVersion=40
maxMinorVersion=99
maxPatchVersion=99
maxIterationVersion=999

function onMajor() {
  if ((  majorVersion < maxMajorVersion )); then
    majorVersion=$((majorVersion + 1))
    minorVersion=0
    patchVersion=0
    iterationVersion=0
  else
    log_error_with_tag "version-number" "majorVersion is already at maximum value"
    exit 1
  fi
}

function onMinor() {
    if (( minorVersion < maxMinorVersion )); then
        minorVersion=$((minorVersion + 1))
        patchVersion=0
        iterationVersion=0
    else
        onMajor
    fi
}

function onPatch() {
    if (( patchVersion < maxPatchVersion )); then
        patchVersion=$((patchVersion + 1))
        iterationVersion=0
    else
        onMinor
    fi
}

function onIteration() {
    if (( iterationVersion < maxIterationVersion )); then
        iterationVersion=$((iterationVersion + 1))
    else
        onPatch
    fi
}

if [ -z "$1" ]; then
    log_error_with_tag "version-number" "head commit sha not provided"
    exit 1
fi

if ! git describe --tags --exact-match "$1" >/dev/null 2>&1; then
    log_info_with_tag "version-number" "could not find any tags"
fi

commitTags=$(git tag --points-at "$1")

release=0

if [ -z "$commitTags" ]; then
    log_info_with_tag "version-computer" "could not find any valid release tags"
fi

log_info_with_tag "version-computer" "current version name is ${majorVersion}.${minorVersion}.${patchVersion}.${iterationVersion}"
log_info_with_tag "version-computer" "current version code is $((majorVersion * 1000000 + minorVersion * 10000 + patchVersion * 1000 + iterationVersion))"

versionTag=""

for tag in $commitTags; do
    tagName=$(echo "$tag" | cut -d_ -f1)

    if [[ " ${relevantTags[*]} " == *" $tagName "* ]]; then
        versionTag=$tagName
        release=1

        break
    fi
done

if [ -z "$versionTag" ] && [ $release -eq 1 ]; then
    log_error_with_tag "version-number" "could not find valid version tags"
    exit 1
fi

if [ $release -eq 1 ]; then
  case $versionTag in
      "major") onMajor ;;
      "minor") onMinor ;;
      "patch") onPatch ;;
      "iteration") onIteration ;;
      *)
          log_error_with_tag "version-number" "invalid version tag"
          exit 1
          ;;
  esac
fi

log_info_with_tag "version-computer" "next version name is ${majorVersion}.${minorVersion}.${patchVersion}.${iterationVersion}"
log_info_with_tag "version-computer" "next version code is $((majorVersion * 1000000 + minorVersion * 10000 + patchVersion * 1000 + iterationVersion))"

sed -i -e "s/^version.major=.*/version.major=${majorVersion}/" $propertiesPath
sed -i -e "s/^version.minor=.*/version.minor=${minorVersion}/" $propertiesPath
sed -i -e "s/^version.patch=.*/version.patch=${patchVersion}/" $propertiesPath
sed -i -e "s/^version.iteration=.*/version.iteration=${iterationVersion}/" $propertiesPath

log_info_with_tag "version-computer" "updated properties file"