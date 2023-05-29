{ pkgs, ... }:
{
  home.packages = [ pkgs.neofetch ];
  home.file.".config/neofetch/config.conf" = {
    text = ''
      print_info() {
        prin " \n \n ╭───────┤  $(color 4)Nix  $(color 15)├───────╮"
        info " " kernel
        # info " " model
        # info "﬙ " cpu
        info "﬙ " gpu
        info " " de
        info " " shell
        info " " term
        info "󰏖 " packages
        info " " memory
        info "󰔛 " uptime
        prin " \n \n ╰─────────────────────────╯"
        prin " \n \n \n \n $(color 1) \n $(color 2) \n $(color 3) \n $(color 4) \n $(color 5) \n $(color 6) \n $(color 7) \n $(color 0)"
      }

      kernel_shorthand="off"
      uptime_shorthand="on"
      memory_percent="on"
      memory_unit="gib"
      package_managers="on"
      shell_path="off"
      shell_version="off"
      cpu_brand="off"
      cpu_speed="off"
      cpu_cores="off"
      cpu_temp="off"
      gpu_brand="on"
      gpu_type="all"
      refresh_rate="off"
      colors=(distro)
      bold="off"
      separator=""

      image_backend="ascii" 
      image_source="/home/focus/.config/smile.txt" 
      image_loop="true"
      crop_mode="normal" # normal fit fill
      crop_offset="center" 
      gap=0 
    '';
  };
}
