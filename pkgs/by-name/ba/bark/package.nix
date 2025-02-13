{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, alsa-lib
, speexdsp
}:
rustPlatform.buildRustPackage {
  pname = "bark";
  version = "unstable-2023-08-22";
  src = fetchFromGitHub {
    owner = "haileys";
    repo = "bark";
    rev = "2586b9fb58b496f8ef06f516c9cd3aace77521f7";
    hash = "sha256-sGroae6uJhB9UIpFmvt520Zs9k0ir7H8pGkhKJmVWek=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-WqJZoYpOQQGJGvND2R1o2nvK5P24z7YeJ9i26mai45M=";
  buildInputs = [ alsa-lib speexdsp ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Live sync audio streaming for local networks";
    homepage = "https://github.com/haileys/bark";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ samw ];
    platforms = lib.platforms.linux;
    mainProgram = "bark";
  };
}

