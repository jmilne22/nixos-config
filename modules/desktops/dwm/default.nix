{ config, pkgs, inputs, ... }:
let
  # Keep the launcher theme in the store; no files in ~/.config are overwritten.
  rofiConfig = pkgs.writeText "chadwm-rofi.rasi" (
    builtins.replaceStrings
      [ ''@theme "everblush"'' ]
      [ ''@theme "${inputs.chadwm}/rofi/themes/nord.rasi"'' ]
      (builtins.readFile "${inputs.chadwm}/rofi/config.rasi")
  );
  launcher = pkgs.writeShellScript "chadwm-launcher" ''
    # This is an X11 session, even when testing from a Wayland desktop.
    unset WAYLAND_DISPLAY
    export XDG_SESSION_TYPE=x11
    exec ${pkgs.rofi}/bin/rofi -config ${rofiConfig} -show drun
  '';

  # Status2d colors match chadwm's Nord theme. No distro update checker or
  # hard-coded battery/interface names from the upstream bar script.
  status = pkgs.writeShellApplication {
    name = "chadwm-status";
    runtimeInputs = with pkgs; [ coreutils gawk procps networkmanager wireplumber xsetroot ];
    text = ''
      while true; do
        memory=$(free -h | awk '/^Mem:/ {print $3}')
        network=$(nmcli -t -f STATE general 2>/dev/null || true)
        case "$network" in
          connected*) network="Online" ;;
          *) network="Offline" ;;
        esac
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null |
          awk '{if ($0 ~ /MUTED/) print "Muted"; else printf "%.0f%%", $2 * 100}' || true)
        volume=''${volume:-N/A}
        battery=""
        for supply in /sys/class/power_supply/*; do
          [[ -r "$supply/type" && -r "$supply/capacity" ]] || continue
          [[ $(cat "$supply/type") == Battery ]] || continue
          battery=" BAT $(cat "$supply/capacity")% |"
          break
        done
        clock=$(date '+%a %d %b  %H:%M')
        xsetroot -name "^c#2A303C^^b#81A1C1^ MEM $memory ^b#3B4252^^c#D8DEE9^ NET $network | VOL $volume |$battery ^b#81A1C1^^c#2A303C^ $clock ^d^" || exit 0
        sleep 3
      done
    '';
  };

  chadwm = (pkgs.dwm.override {
    conf = null; # Keep the old local config.def.h for reverting to vanilla dwm.
    patches = [ ];
    extraLibs = with pkgs; [ imlib2 libxrender ];
  }).overrideAttrs (old: {
    pname = "chadwm";
    version = "6.5-${inputs.chadwm.shortRev}";
    src = inputs.chadwm.outPath + "/chadwm";
    postPatch = (old.postPatch or "") + ''
      substituteInPlace config.mk --replace-fail "-march=native" ""
      substituteInPlace config.def.h \
        --replace-fail 'themes/tundra.h' 'themes/nord.h' \
        --replace-fail '/usr/bin/pactl' '${pkgs.pulseaudio}/bin/pactl' \
        --replace-fail '"set-sink-volume", "0"' '"set-sink-volume", "@DEFAULT_SINK@"' \
        --replace-fail '"set-sink-mute",   "0"' '"set-sink-mute",   "@DEFAULT_SINK@"' \
        --replace-fail '"/usr/bin/light", "-A", "5"' '"${pkgs.brightnessctl}/bin/brightnessctl", "set", "+5%"' \
        --replace-fail '"/usr/bin/light", "-U", "5"' '"${pkgs.brightnessctl}/bin/brightnessctl", "set", "5%-"' \
        --replace-fail '"eww", "-c", "/home/siduck/.config/chadwm/eww", "open" , "eww"' '"${launcher}"' \
        --replace-fail 'SHCMD("rofi -show drun")' 'SHCMD("${launcher}")' \
        --replace-fail '1 << 8,' '1 << 1,' \
        --replace-fail 'SHCMD("killall bar.sh chadwm")' 'SHCMD("kill -TERM $PPID")'
    '';
    # NixOS launches `dwm`. Scope the helper processes to this session and keep
    # upstream's restart-on-success behavior (Super+Shift+r).
    postInstall = (old.postInstall or "") + ''
      cat > "$out/bin/dwm" <<'SCRIPT'
      #!${pkgs.bash}/bin/bash
      wm_pid=
      ${status}/bin/chadwm-status &
      bar_pid=$!
      ${pkgs.picom}/bin/picom --backend xrender &
      compositor_pid=$!
      cleanup() {
        kill "$bar_pid" "$compositor_pid" ''${wm_pid:+"$wm_pid"} 2>/dev/null || true
        wait 2>/dev/null || true
      }
      trap cleanup EXIT
      trap 'exit 0' HUP INT TERM
      while true; do
        "$(dirname "$0")/chadwm" &
        wm_pid=$!
        wait "$wm_pid"
        result=$?
        wm_pid=
        [ "$result" -eq 0 ] || break
      done
      SCRIPT
      chmod +x "$out/bin/dwm"
    '';
  });
in
{
  services.xserver.enable = true;

  services.xserver.displayManager.startx = {
    enable = true;
    generateScript = true;
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    package = chadwm;
  };

  xdg.portal.config.common.default = [ "gtk" ];

  environment.systemPackages = with pkgs; [
    st
    dmenu
    rofi
    maim
    xclip
  ];

  fonts.packages = [ pkgs.iosevka ];
}
