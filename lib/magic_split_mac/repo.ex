defmodule MagicSplitMac.Repo do
  use Ecto.Repo,
    otp_app: :magic_split_mac,
    adapter: Ecto.Adapters.SQLite3
end
