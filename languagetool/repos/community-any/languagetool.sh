#!/bin/bash

file_present=false
asked_for_help=false
start_server=false
https_server=false

declare -a argv=("$@")

i=0
for arg in "$@"; do
  if [[ $arg != -* ]]; then
    file_present=true
  fi
  if [[ $arg == --config* ]]; then
    start_server=true
    https_server=true
  fi
  if [[ $arg == --http ]]; then
    start_server=true
    unset argv[$i]
  fi
  if [[ $arg == -h ]]; then
    asked_for_help=true
    unset argv[$i]
  fi
  if [[ $arg == --help ]]; then
    asked_for_help=true
    unset argv[$i]
  fi
  ((i++))
done

CP=/usr/share/languagetool
for name in /usr/share/java/languagetool/*.jar ; do
  CP=$CP:$name
done

CLI_command='org.languagetool.commandline.Main'
GUI_command='org.languagetool.gui.Main'
NSRV_command='org.languagetool.server.HTTPServer'
SSRV_command='org.languagetool.server.HTTPSServer'

if $asked_for_help; then
  echo "Command-line interface (CLI) help:"
  "$JAVA_HOME/bin/java" -cp $CP $CLI_command -h | sed "s/java -jar languagetool-commandline.jar/languagetool/"
  echo
  echo "Graphical user interface (GUI) help:"
  "$JAVA_HOME/bin/java" -cp $CP $GUI_command -h | sed "s/java org.languagetool.gui.Main/languagetool/"
  echo
  echo "HTTP server help:"
  "$JAVA_HOME/bin/java" -cp $CP $NSRV_command -h | sed "s/HTTPServer/languagetool --http/"
  echo
  echo "HTTPS server help:"
  "$JAVA_HOME/bin/java" -cp $CP $SSRV_command -h | sed "s/HTTPSServer/languagetool/"
else
  if $start_server; then
    if $https_server; then
      "$JAVA_HOME/bin/java" -cp $CP $SSRV_command "${argv[@]}"
    else
      "$JAVA_HOME/bin/java" -cp $CP $NSRV_command "${argv[@]}"
    fi
  else
    if $file_present; then
      "$JAVA_HOME/bin/java" -cp $CP $CLI_command "${argv[@]}"
    else
      "$JAVA_HOME/bin/java" -cp $CP $GUI_command "${argv[@]}"
    fi
  fi
fi

