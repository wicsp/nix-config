{ config, pkgs, ... }:
let
  # nixpkgs 2026.06.09 receives HTTP 412 from Bilibili for the verified M3.3
  # source. Pin the current upstream stable release until the lock catches up.
  ytDlpForBilibili = pkgs.yt-dlp.overrideAttrs {
    version = "2026.07.04";
    src = pkgs.fetchFromGitHub {
      owner = "yt-dlp";
      repo = "yt-dlp";
      tag = "2026.07.04";
      hash = "sha256-+oHcVylLXFJTRR6jXF6IXvgntXJz0tRdtnwTruRPkoc=";
    };
  };
  # CoreML is optional, and its small Objective-C shim currently crashes the
  # nixpkgs Darwin linker. Keep the Metal backend used for local ASR.
  whisperCppForLumio =
    (pkgs.whisper-cpp.override {
      coreMLSupport = false;
    }).overrideAttrs
      (previousAttrs: {
        # nixpkgs appends this target on every Darwin build, even when CoreML is
        # disabled. Remove the resulting references to the nonexistent target.
        postPatch = previousAttrs.postPatch + ''
          substituteInPlace src/CMakeLists.txt \
            --replace-fail 'install(TARGETS whisper.coreml LIBRARY)' ""
        '';
      });
in
{
  programs.ssh.settings."github.com".identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";

  # Web frontend tools - only needed on local dev machine
  home.packages = with pkgs; [
    nodejs_24
    typescript
    typescript-language-server
    # HTML/CSS/JSON/ESLint language servers extracted from vscode
    vscode-langservers-extracted
    tailwindcss-language-server
    emmet-ls
    # Lumio bilibili-summary-v4: subtitle-free public videos use local ASR.
    ytDlpForBilibili
    whisperCppForLumio
  ];
}
# {
#   programs.ssh = {
#     enable = true;
#     extraConfig = ''
#       Host github.com
#         Hostname github.com
#         # github is controlled by macsp~
#         IdentityFile ~/.ssh/id_rsa_github
#         # Specifies that ssh should only use the identity file explicitly configured above
#         # required to prevent sending default identity files first.
#         IdentitiesOnly yes
#       # Amax server
#       Host amax
#         HostName 100.74.193.128
#         Port 22
#       # AliCloud server
#       Host mio
#         HostName 120.76.156.100
#         Port 4922
#       # parallels ubuntu
#       Host nixpara
#         HostName 10.211.55.12
#         User wicsp
#         Port 4922
#       # Lenovo nixos
#       Host nixos
#         HostName 192.168.1.105
#         User wicsp
#         Port 22
#       # Super Computer Center
#       Host cs
#         HostName 10.50.0.232
#         User wicsp
#         Port 22
#       Host login1
#         HostName 10.50.60.14
#         User opadmin
#         Port 22
#         IdentityFile ~/.ssh/cszx_rsa
#       Host login2
#         HostName 10.50.60.15
#         User opadmin
#         Port 22
#         IdentityFile ~/.ssh/cszx_rsa
#       Host login3
#         HostName 10.50.0.140
#         User opadmin
#         Port 22
#         IdentityFile ~/.ssh/cszx_rsa
#       Host admin1
#         HostName 10.50.60.5
#         User opadmin
#         Port 22
#         IdentityFile ~/.ssh/cszx_rsa
#       Host admin2
#         HostName 10.50.60.6
#         User opadmin
#         Port 22
#         IdentityFile ~/.ssh/cszx_rsa
#       # lab servers
#       Host lab
#         HostName server2
#         User guowenbin
#         Port 8029
#       Host imp
#         HostName server1
#         User guowenbin
#         Port 8021
#       Host peppa
#         HostName server1
#         User guowenbin
#         Port 8022
#       Host rick
#         HostName server2
#         User guowenbin
#         Port 8023
#       Host shiyuan
#         HostName server2
#         User guowenbin
#         Port 8024
#       Host swift
#         HostName server2
#         User guowenbin
#         Port 8025
#       Host kunpeng
#         HostName server2
#         User guowenbin
#         Port 8026
#       Host fenghuang
#         HostName server2
#         User guowenbin
#         Port 8027
#       Host zhuque
#         HostName server2
#         User guowenbin
#         Port 8028
#       Host xuanwu
#         HostName server2
#         User guowenbin
#         Port 8029
#       Host qilin
#         HostName server2
#         User guowenbin
#         Port 8030
#       Host zishu
#         HostName server2
#         User guowenbin
#         Port 8031
#       Host chouniu
#         HostName server2
#         User guowenbin
#         Port 8032
#       Host yinhu
#         HostName server2
#         User guowenbin
#         Port 8033
#       Host maotu
#         HostName server2
#         User guowenbin
#         Port 8034
#       Host sishe
#         HostName server2
#         User guowenbin
#         Port 8036
#       Host wuma
#         HostName server2
#         User guowenbin
#         Port 8037
#       Host weiyang
#         HostName server2
#         User guowenbin
#         Port 8038
#       Host storage
#         HostName server2
#         User special
#         Port 8099
#     '';
#   };
# }
