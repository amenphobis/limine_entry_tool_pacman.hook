#!/bin/bash

esp=$(bootctl --print-esp-path 2>/dev/null)

while read -r target;
    do
        uki_entry=$(grep default_uki /etc/mkinitcpio.d/$target.preset)
        uki_path=${uki_entry#*=} ; uki_path=${uki_path//'"'/}
        uki_fallback_path=${uki_path//'.efi'/'-fallback.efi'}

        if [ -f "$uki_path" ]
            then
            limine-entry-tool --add-uki "$target---UKI" "$uki_path"
            echo "$target Kernel-UKI wurde erfolgreich in Limine Config hinzugefügt"
            else
            echo "$target Kernel-UKI nicht vorhanden"
        fi

        if [ -f "$uki_fallback_path" ]
            then
            limine-entry-tool --add-uki "$target-fallback---UKI" "$uki_fallback_path"
            echo "$target Kernel Fallback UKI wurde erfolgreich in Limine Config hinzugefügt"
            else
            echo "$target Kernel Fallback UKI nicht vorhanden"
        fi

        if [ -f "/$esp/initramfs-$target.img" ]
            then
            limine-entry-tool --add "$target" "$esp/initramfs-$target.img" "$esp/vmlinuz-$target"
            echo "$target Kernel wurde erfolgreich in Limine Config hinzugefügt"
            else
            echo "$target Kernel nicht vorhanden"
        fi

        if [ -f "$esp/initramfs-$target-fallback.img" ]
            then
            limine-entry-tool --add "$target" "$esp/initramfs-$target-fallback.img" "$esp/vmlinuz-$target"
            echo "$target Fallback Kernel wurde erfolgreich in Limine Config hinzugefügt"
            else
            echo "$target Kernel konnte nicht gefunden werden"
        fi
    done
