{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  supabase-cli,
  nix-update-script,
}:

buildGoModule rec {
  pname = "supabase-cli";
  version = "2.22.8";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-faW/1oBbYRq+8vQbipYXNTVIftXkKM3uGPbNNPeZivY=";
  };

  vendorHash = "sha256-gh8AXUxnDU8trXCJN0aFZ/U4RadzOjDXV9tYCAFRbA0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/supabase/cli/internal/utils.Version=${version}"
  ];

  doCheck = false; # tests are trying to connect to localhost

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    rm $out/bin/{docs,listdep}
    mv $out/bin/{cli,supabase}

    installShellCompletion --cmd supabase \
      --bash <($out/bin/supabase completion bash) \
      --fish <($out/bin/supabase completion fish) \
      --zsh <($out/bin/supabase completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = supabase-cli;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = licenses.mit;
    maintainers = with maintainers; [
      gerschtli
      kashw2
    ];
    mainProgram = "supabase";
  };
}
