defmodule MagicSplitMacWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use MagicSplitMacWeb, :html

  embed_templates "lee_html/*"
end
