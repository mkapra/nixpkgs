{ lib
, stdenv
, python3
, fetchFromGitHub
, nodejs_24
, yarn-berry_4
}:
let
 yarn-berry = yarn-berry_4;
 nodejs = nodejs_24;
in

stdenv.mkDerivation (finalAttrs: {
 pname = "ansible-language-server";
 version = "25.12.0";

 src = fetchFromGitHub {
   owner = "ansible";
   repo = "vscode-ansible";
   tag = "v${finalAttrs.version}";
   sha256 = "sha256-J1o1VdJ1P7XXXZRfIsPve3JY/9/5zary/VqWvjm/Mw8=";
 };

 nativeBuildInputs = [
   python3
   nodejs
   yarn-berry.yarnBerryConfigHook
 ];

 missingHashes = ./missing-hashes.json;
 offlineCache = yarn-berry.fetchYarnBerryDeps {
   inherit (finalAttrs) src missingHashes;
   hash = "sha256-otsmGsJfB00LQMALUxV3r9cYWRls3zsirmG69upLn1U=";
 };

 buildPhase = ''
   ${yarn-berry}/bin/yarn run build
 '';

 installPhase = ''
   mkdir -p $out
   cp -r packages/ansible-language-server/bin out $out
 '';

  meta = {
    changelog = "https://github.com/ansible/ansible-language-server/releases/tag/v${finalAttrs.version}";
    description = "Ansible Language Server";
    mainProgram = "ansible-language-server";
    homepage = "https://github.com/ansible/ansible-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkapra ];
  };
})
