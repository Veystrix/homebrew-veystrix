class Veystrix < Formula
  desc "Local LLM inference engine & terminal coding agent for Apple Silicon"
  homepage "https://github.com/Veystrix/Veystrix-Engine"
  url "https://github.com/Veystrix/Veystrix-Engine/releases/download/v0.1.0/veystrix-engine-0.1.0-arm64.tar.gz",
      using: :nounzip
  sha256 "05ec6cfc287cfe5ecdc7c3ab8ffb18201a47422c7d54a0752038677a55cb4f23"
  version "0.1.0"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    libexec.install "veystrix-engine-0.1.0-arm64.tar.gz" => "veystrix-engine.tar.gz"
    (bin/"veystrix").write <<~SH
      #!/bin/sh
      # Unpacks the sealed engine on first run of each version, then runs it.
      set -e
      ENGINE="$HOME/.veystrix/engine"
      if [ "$(cat "$ENGINE/.installed-version" 2>/dev/null)" != "0.1.0" ]; then
        echo "veystrix: setting up version 0.1.0 (first run only) ..." >&2
        mkdir -p "$HOME/.veystrix"
        STAGE="$(mktemp -d "$HOME/.veystrix/engine.new-XXXXXX")"
        tar -xzf "#{libexec}/veystrix-engine.tar.gz" -C "$STAGE"
        rm -rf "$HOME/.veystrix/engine.previous"
        [ -d "$ENGINE" ] && mv "$ENGINE" "$HOME/.veystrix/engine.previous"
        mv "$STAGE/engine" "$ENGINE" && rmdir "$STAGE"
        rm -rf "$HOME/.veystrix/engine.previous"
        echo "0.1.0" > "$ENGINE/.installed-version"
      fi
      VEYSTRIX_INSTALLER=brew exec "$ENGINE/bin/veystrix" "$@"
    SH
  end

  def caveats
    <<~EOS
      Veystrix is installed. Run `veystrix` in any project folder to start.
      Models are downloaded on request from inside Veystrix (/models).
    EOS
  end

  test do
    assert_match "veystrix", shell_output("#{bin}/veystrix --version")
  end
end
