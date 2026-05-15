defmodule MagicSplitMacWeb.PageController do
  use MagicSplitMacWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
