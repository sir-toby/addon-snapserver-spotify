#!/usr/bin/env bash

# Configuration generation
bashio::log.info "Generating SnapServer configuration..."
config="/etc/snapserver.conf"

# Stream
echo "[stream]" > "${config}"

if bashio::config.has_value 'stream.codec'; then
    echo "codec = $(bashio::config 'stream.codec')" >> "${config}"
fi

if bashio::config.has_value 'stream.sampleformat'; then
    echo "sampleformat = $(bashio::config 'stream.sampleformat')" >> "${config}"
fi

# HTTP
echo "[http]" >> "${config}"

if bashio::config.has_value 'http.enabled'; then
    echo "enabled = $(bashio::config 'http.enabled')" >> "${config}"
fi

if bashio::config.has_value 'http.bind_to_address'; then
    echo "bind_to_address = $(bashio::config 'http.bind_to_address')" >> "${config}"
fi

# HTTP document root
echo "doc_root = /usr/share/snapserver/snapweb/" >> "${config}"

# TCP
echo "[tcp]" >> "${config}"

if bashio::config.has_value 'tcp.enabled'; then
    echo "enabled = $(bashio::config 'tcp.enabled')" >> "${config}"
fi

# Logging
echo "[logging]" >> "${config}"

if bashio::config.has_value 'logging.enabled'; then
    echo "debug = $(bashio::config 'logging.enabled')" >> "${config}"
fi

# Start services
bashio::log.info "Starting SnapServer..."
snapserver &  # Run snapserver in the background

bashio::log.info "Starting SnapClient..."
snapclient &  # Run snapclient in the background

# Wait for all background processes to finish
wait