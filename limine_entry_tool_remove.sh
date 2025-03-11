#!/bin/bash

while read -r target;
    do
    limine-entry-tool --remove-uki "$target---efi"
    echo "Removed $target---efi"
    limine-entry-tool --remove "$target"
    echo "Removed $target"
    done

