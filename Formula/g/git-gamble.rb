class GitGamble < Formula
  desc "Tool that blends TDD (Test Driven Development) + TCR (test && commit || revert)"
  homepage "https://git-gamble.is-cool.dev"
  url "https://gitlab.com/pinage404/git-gamble/-/archive/version/2.9.0/git-gamble-version-2.9.0.tar.bz2"
  sha256 "0446df2af6d36dbda0afb69fc08fd8129fed756310d9fbecd9b73115920ae647"
  license "ISC"
  head "https://gitlab.com/pinage404/git-gamble.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "git-gamble"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"git-gamble", "generate-shell-completions")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "Git Gamble"
    system "git", "config", "user.email", "git@gamble"

    system "sh", "-c", "echo 'failing' > 'some_file'"
    system bin/"git-gamble", "--red", "--", "false"
    assert_equal "failing", shell_output("cat some_file").strip

    system "sh", "-c", "echo 'should pass but still failing' > 'some_file'"
    system bin/"git-gamble", "--green", "--", "false"
    assert_equal "failing", shell_output("cat some_file").strip

    system "sh", "-c", "echo 'passing' > 'some_file'"
    system bin/"git-gamble", "--refactor", "--", "true"
    assert_equal "passing", shell_output("cat some_file").strip
  end
end


# podman run --name brew --workdir /w --volume $PWD:/w --interactive --tty docker.io/homebrew/brew:latest bash
# cd "$(brew --repository homebrew/core)"
# git remote add local /w
# export HOMEBREW_NO_INSTALL_FROM_API=1
# brew create https://gitlab.com/pinage404/git-gamble/-/archive/version/2.9.0/git-gamble-version-2.9.0.tar.bz2
# HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new git-gamble
