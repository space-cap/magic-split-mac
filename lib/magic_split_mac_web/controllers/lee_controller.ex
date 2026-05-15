defmodule MagicSplitMacWeb.LeeController do
  use MagicSplitMacWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
