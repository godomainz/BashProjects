#!/bin/bash

log(){
    local MESSAGE="${@}"
    echo "${MESSAGE}"
}

# function log {
#     echo "You called the log function!"
# }

log "Hello"
log "This is fun"