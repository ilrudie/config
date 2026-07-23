return {
  "mason-org/mason.nvim",
  -- Append rather than prepend mason's bin dir to PATH, so locally built tools
  -- (~/go/bin) win over mason's prebuilt binaries. Needed because mason's
  -- prebuilt golangci-lint is compiled with an older Go than the repos target
  -- (e.g. go1.25 build vs go1.26 go.mod), which makes it abort on every lint.
  opts = { PATH = "append" },
}
