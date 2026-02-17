{
  hydenix.hm.hyprland = {
    extraConfig = ''
      input {
          kb_layout = us,ru
          kb_options = grp:win_space_toggle
          # follow_mouse = 1 # не нужно кликать, чтобы сфокусироваться на окне.
          sensitivity = 0 # Позволяет настроить скорость перемещения курсора
          force_no_accel = 0 # Определяет, нужно ли принудительно отключать аппаратное ускорение мыши/тачпада. 0 означает "не принуждать к отключению" (т.е., ускорение используется, если доступно). 1 принудительно отключит его.
          accel_profile = flat # Выбирает профиль акселерации мыши/тачпада. flat означает, что ускорения нет, движение курсора прямо пропорционально движению устройства. Другие варианты могут включать adaptive или high.
          # numlock_by_default = true
          natural_scroll = true
      
          # 🔗 See https://wiki.hyprland.org/Configuring/Variables/#touchpad
          touchpad {
              # natural_scroll = no
              natural_scroll = true
          }
      
      }
      
      # 🔗 See https://wiki .hyprland.org/Configuring/Variables/#gestures
      gestures {
      #     workspace_swipe = true
      #     workspace_swipe_fingers = 3
      }
      
      exec-once = wlsunset -t 5500 -T 5501 -l 50.45 -L 30.52
      # windowrulev2 = opacity 1.00 $& 1.00 $& 0,class:^(kitty)$ # Если нужно убрать прозрачность kitty
      
      # Если нужно убрать отступы, закругления, тень (неон), размытие
      # general {
      #     gaps_in = 0
      #     gaps_out = 0
      #     border_size = 0
      # }
      # 
      # decoration {
      #     rounding = 0
      # 
      #     shadow {
      #         enabled = false
      #     }
      # 
      #     blur {
      #         enabled = false
      #     }
      # }
      
      # windowrulev2 = opacity 1 $& 1 $& 1,class:^(firefox)$ # Если нужно убрать прозрачность firefox

      monitor = eDP-1, 1920x1080, 0x0, 1.25
      env = LIBVA_DRIVER_NAME,iHD # Intel
      cursor {
        no_hardware_cursors = false
      }
    '';
  };
}
