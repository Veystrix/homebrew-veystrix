class VeystrixRender < Formula
  desc "SSD-streamed local MiniMax-H3-Image generation for Apple Silicon"
  homepage "https://github.com/Veystrix/Veystrix-Render"
  url "https://github.com/Veystrix/Veystrix-Render/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c842aea7cf6b9b2eeffc9bd6fe1a2fc4d0e1a7b32c58471313d06a3075a94f3e"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", buildpath
    bin.install_symlink libexec/"bin/veystrix-render"
  end

  def caveats
    <<~EOS
      Get started with Veystrix-Render:
        veystrix-render doctor
        veystrix-render download
        veystrix-render web

      Note: MiniMax-H3-Image model weights are not bundled and are governed
      by the MiniMax-H3-Image Community License (excluding the US, EU, UK,
      and South Korea, and requiring written permission above $1M annual
      revenue or for third-party hosted services).
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/veystrix-render --version")
  end
end
