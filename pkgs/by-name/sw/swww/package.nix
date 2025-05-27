{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lz4,
  libxkbcommon,
  installShellFiles,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swww";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g7h8Ec1et4fWDTv34asFXea6SBIXv3D90Pd+YsnhbXQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cVCE6Mw0h/kXuuxsf8r55Uj9GAVtrxXof6sq3dfd0rk=";

  buildInputs = [
    lz4
    libxkbcommon
    wayland
    wayland-protocols
  ];

  doCheck = false; # Integration tests do not work in sandbox environment

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  postPatch = ''
    # swww uses waybackend, an in-house wayland-scanner implementation. The build script tells it to
    # locate `wayland.xml` via `WaylandProtocol::Client`. This is implemented by querying pkg-config
    # for the data directory of the `wayland` package, which does not contain `wayland.xml` in
    # nixpkgs since we package this file as a part of `wayland-scanner`. To fix this, we modify the
    # upstream build script in order to give it the correct path.
    substituteInPlace "daemon/build.rs" \
      --replace-fail 'WaylandProtocol::Client' \
        'WaylandProtocol::Local(PathBuf::from("${wayland-scanner}/share/wayland/wayland.xml"))'
  '';

  postInstall = ''
    for f in doc/*.scd; do
      local page="doc/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd swww \
      --bash completions/swww.bash \
      --fish completions/swww.fish \
      --zsh completions/_swww
  '';

  meta = {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/LGFae/swww";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mateodd25
      donovanglover
    ];
    platforms = lib.platforms.linux;
    mainProgram = "swww";
  };
})
