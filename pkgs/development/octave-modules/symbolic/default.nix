{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  # Octave's Python (Python 3)
  python,
}:

let
  pythonEnv = python.withPackages (ps: [
    ps.sympy
    ps.mpmath
  ]);

in
buildOctavePackage rec {
  pname = "symbolic";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    tag = "v${version}";
    hash = "sha256-H2242+1zlke4aLoS3gsHpDfopM5oSZ4IpVR3+xxQ0Dc=";
  };

  propagatedBuildInputs = [ pythonEnv ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/symbolic/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
