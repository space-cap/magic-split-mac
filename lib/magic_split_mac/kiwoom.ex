defmodule MagicSplitMac.Kiwoom do
  @moduledoc """
  키움증권 REST API 연동을 담당하는 모듈입니다.
  """

  @doc """
  [au10001] 키움 API 서버로부터 접근 토큰(Access Token)을 발급받습니다.
  """
  def get_token do
    config = Application.get_env(:magic_split_mac, :kiwoom)
    base_url = config[:base_url]
    url = "#{base_url}/oauth2/token"

    body = %{
      "grant_type" => "client_credentials",
      "appkey" => config[:app_key],
      "secretkey" => config[:app_secret]
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
