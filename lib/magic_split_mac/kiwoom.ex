defmodule MagicSplitMac.Kiwoom do
  @moduledoc """
  키움증권 REST API 연동을 담당하는 모듈입니다.
  """

  @doc """
  [au10001] 키움 API 서버로부터 접근 토큰(Access Token)을 발급받습니다.
  """
  def get_token do
    base_url = System.get_env("KIWOOM_BASE_URL")
    url = "#{base_url}/oauth2/token"

    body = %{
      "grant_type" => "client_credentials",
      "appkey" => System.get_env("KIWOOM_APP_KEY"),
      "secretkey" => System.get_env("KIWOOM_APP_SECRET")
    }

    # Content-Type을 키움 규격에 맞춰 설정합니다.
    headers = %{"Content-Type" => "application/json;charset=UTF-8"}

    case Req.post(url, json: body, headers: headers) do
      {:ok, %{status: 200, body: %{"token" => token}}} ->
        {:ok, token}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  주식 현재가를 조회합니다.
  """
  def get_price(stock_code) do
    case get_token() do
      {:ok, token} ->
        base_url = System.get_env("KIWOOM_BASE_URL")
        url = "#{base_url}/v1/quotes/current/#{stock_code}"
        headers = [{"Authorization", "Bearer #{token}"}]

        Req.get!(url, headers: headers).body

      error ->
        error
    end
  end
end
