
{ config, pkgs, ... }:
let
in
{
    fileSystems."/mnt/share" = {
      device = "//10.0.0.2/Share";
      fsType = "cifs";
      options = let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };

    fileSystems."/mnt/home" = {
      device = "//10.0.0.2/Home";
      fsType = "cifs";
      options = let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };
}
