#!/bin/bash

propertiesPath="$(pwd)/version.properties"

majorVersion=$(awk -F "=" '/version.major/ {print $2}' "$propertiesPath")
minorVersion=$(awk -F "=" '/version.minor/ {print $2}' "$propertiesPath")
patchVersion=$(awk -F "=" '/version.patch/ {print $2}' "$propertiesPath")
iterationVersion=$(awk -F "=" '/version.iteration/ {print $2}' "$propertiesPath")

echo "v${majorVersion}.${minorVersion}.${patchVersion}.${iterationVersion}"