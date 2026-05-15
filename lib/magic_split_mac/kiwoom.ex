defmodule MagicSplitMac.Kiwoom do
  @moduledoc """
  키움증권 REST API 연동을 담당하는 모듈입니다.
  """

  @doc """
  [au10001] 유효한 접근 토큰(Access Token)을 가져옵니다. (메모리 캐시 활용)
  """
  def get_token do
    MagicSplitMac.Kiwoom.TokenServer.get_token()
  end

  @doc """
  [ka10001] 주식기본정보를 조회합니다.
  """
  def get_stock_info(stock_code) do
    case get_token() do
      {:ok, token} ->
        config = Application.get_env(:magic_split_mac, :kiwoom)
        base_url = config[:base_url]
        url = "#{base_url}/api/dostk/stkinfo"

        body = %{"stk_cd" => stock_code}

        headers = %{
          "Content-Type" => "application/json;charset=UTF-8",
          "authorization" => "Bearer #{token}",
          "api-id" => "ka10001",
          "cont-yn" => "N",
          "next-key" => ""
        }

        case Req.post(url, json: body, headers: headers) do
          {:ok, %{status: 200, body: body}} ->
            {:ok, body}

          {:ok, %{body: body}} ->
            {:error, body}

          {:error, reason} ->
            {:error, reason}
        end

      error ->
        error
    end
  end
end
