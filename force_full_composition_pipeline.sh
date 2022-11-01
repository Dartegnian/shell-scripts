#! /usr/bin/env bash
s="$(nvidia-settings -q CurrentMetaMode -t)"

if [[ "${s}" != "" ]]; then
  s="${s#*" :: "}"
  nvidia-settings -a CurrentMetaMode="${s//\}/, ForceFullCompositionPipeline=On\}}"
fi
