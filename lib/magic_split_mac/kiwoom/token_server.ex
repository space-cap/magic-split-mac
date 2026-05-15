defmodule MagicSplitMac.Kiwoom.TokenServer do
  use GenServer
  require Logger

  @name __MODULE__

  # 클라이언트 API
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{token: nil, expires_at: nil}, name: @name)
  end

  @doc "유효한 토큰을 가져오거나, 없으면 새로 발급받습니다."
  def get_token do
    GenServer.call(@name, :get_token)
  end

  @doc "메모리에 저장된 토큰을 즉시 삭제합니다."
  def clear_token do
    GenServer.cast(@name, :clear_token)
  end

  # 서버 콜백
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:clear_token, _state) do
    Logger.info("메모리에서 토큰을 성공적으로 삭제했습니다.")
    {:noreply, %{token: nil, expires_at: nil}}
  end

  @impl true
  def handle_call(:get_token, _from, state) do
    if valid_token?(state) do
      # 금고에 유효한 토큰이 있으면 바로 반환
      {:reply, {:ok, state.token}, state}
    else
      # 없으면 새로 발급
      Logger.info("토큰이 없거나 만료되었습니다. 새로 발급받습니다...")
      case fetch_new_token() do
        {:ok, token, expires_at} ->
          new_state = %{token: token, expires_at: expires_at}
          {:reply, {:ok, token}, new_state}

        error ->
          {:reply, error, state}
      end
    end
  end

  defp valid_token?(%{token: nil}), do: false
  defp valid_token?(%{expires_at: expires_at}) do
    # 현재 시간보다 1분 정도 여유를 두고 확인 (네트워크 지연 대비)
    DateTime.compare(DateTime.utc_now(), DateTime.add(expires_at, -60)) == :lt
  end

  defp fetch_new_token do
    config = Application.get_env(:magic_split_mac, :kiwoom)
    url = "#{config[:base_url]}/oauth2/token"
    
    body = %{
      "grant_type" => "client_credentials",
      "appkey" => config[:app_key],
      "secretkey" => config[:app_secret]
    }

    case Req.post(url, json: body) do
      {:ok, %{status: 200, body: %{"token" => token, "expires_dt" => expires_dt}}} ->
        {:ok, token, parse_expires_dt(expires_dt)}
      {:ok, %{body: body}} ->
        {:error, body}
      {:error, reason} ->
        {:error, reason}
    end
  end

  # "20241107083713" -> DateTime 변환
  defp parse_expires_dt(<<y::binary-4, m::binary-2, d::binary-2, h::binary-2, mi::binary-2, s::binary-2>>) do
    [y, m, d, h, mi, s] = Enum.map([y, m, d, h, mi, s], &String.to_integer/1)
    
    {:ok, naive} = NaiveDateTime.new(y, m, d, h, mi, s)
    # 키움 API 시간은 한국 시간(KST, UTC+9) 기준일 가능성이 높으므로 UTC로 보정합니다.
    # 만약 서버 시간이 UTC 기준이라면 바로 변환하면 됩니다.
    DateTime.from_naive!(naive, "Etc/UTC") 
    |> DateTime.add(-9, :hour) # 한국 시간 -> UTC 변환
  end
end
