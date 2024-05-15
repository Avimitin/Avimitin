inputs:

final: prev: {
  my-nvim-src = inputs.nvim.outPath;

  tmux-fingers = final.stdenvNoCC.mkDerivation rec {
    name = "tmux-finger";

    nativeBuildInputs = [
      final.crystal
      final.shards
    ];

    src = final.fetchFromGitHub {
      owner = "Avimitin";
      repo = "tmux-fingers";
      rev = "7e693d40cdac2a6a92f90105a17592f9ab53fe19";
      hash = "sha256-n7mfTX8hI5CyCIZJDHhiAaWyT1bvD2lkn4NddSGmaBA=";
    };

    buildPhase = ''
      shards build --production
    '';

    passthru.tmux-script = "share/tmux/tmux-fingers.tmux";

    installPhase = ''
      mkdir -p $out/bin $out/share/tmux

      mv bin/tmux-fingers $out/bin

      tee -a $out/${passthru.tmux-script} <<EOF
      #/bin/bash
      tmux run "$out/bin/tmux-fingers load-config"
      exit $?
      EOF
      chmod +x $out/${passthru.tmux-script}
    '';
  };
}
