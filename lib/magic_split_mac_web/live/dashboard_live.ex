defmodule MagicSplitMacWeb.DashboardLive do
  use MagicSplitMacWeb, :live_view

  @stocks [
    %{id: "005930", name: "삼성전자", price: 72500, change: 1.2, qty: 100, avg_price: 71000, level: 2},
    %{id: "000660", name: "SK하이닉스", price: 115000, change: -0.8, qty: 50, avg_price: 116500, level: 3},
    %{id: "035420", name: "NAVER", price: 195000, change: 0.5, qty: 30, avg_price: 192000, level: 1},
    %{id: "005380", name: "현대차", price: 205000, change: -1.5, qty: 20, avg_price: 210000, level: 4},
    %{id: "035720", name: "카카오", price: 48500, change: 2.1, qty: 200, avg_price: 47000, level: 1}
  ]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, 
     socket 
     |> assign(:page_title, "실시간 잔고 - MagicSplit")
     |> assign(:total_asset, 25840000)
     |> assign(:daily_profit, 1245000)
     |> assign(:daily_rate, 4.8)
     |> assign(:tick_toggle, true)
     |> stream(:stocks, @stocks)}
  end

  @impl true
  def handle_info(:tick, socket) do
    updated_stocks = Enum.map(socket.assigns.streams.stocks, fn {_id, stock} ->
      change = (:rand.uniform(200) - 100)
      %{stock | price: stock.price + change}
    end)

    {:noreply, 
     socket 
     |> assign(:tick_toggle, !socket.assigns.tick_toggle)
     |> stream(:stocks, updated_stocks, reset: true)}
  end

  @impl true
  def handle_event("select_stock", %{"id" => id}, socket) do
    # 상세 설정 페이지로 이동 (독립적인 경로 사용)
    {:noreply, push_navigate(socket, to: ~p"/stocks/#{id}/settings")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-screen bg-slate-950 text-slate-200 overflow-hidden font-sans">
      <%!-- 왼쪽 사이드바 --%>
      <aside class="w-64 bg-slate-900 border-r border-slate-800 flex flex-col shrink-0">
        <div class="p-6">
          <h1 class="text-xl font-bold text-slate-100 flex items-center gap-2">
            <div class="relative flex h-3 w-3">
              <span class={[
                "animate-ping absolute inline-flex h-full w-full rounded-full opacity-75",
                @tick_toggle && "bg-emerald-400",
                !@tick_toggle && "bg-emerald-500"
              ]}></span>
              <span class="relative inline-flex rounded-full h-3 w-3 bg-emerald-500"></span>
            </div>
            MagicSplit <span class="text-xs font-light text-slate-500 uppercase tracking-tighter">Mac</span>
          </h1>
        </div>

        <nav class="flex-1 px-4 space-y-2">
          <a href="#" class="flex items-center gap-3 px-4 py-3 bg-indigo-600/10 text-indigo-400 rounded-xl border border-indigo-500/20">
            <.icon name="hero-presentation-chart-line" class="w-5 h-5" />
            <span class="font-medium">실시간 잔고</span>
          </a>
          <a href="#" class="flex items-center gap-3 px-4 py-3 text-slate-400 hover:bg-slate-800 rounded-xl transition-all">
            <.icon name="hero-document-text" class="w-5 h-5" />
            <span>매매 일지</span>
          </a>
          <a href="#" class="flex items-center gap-3 px-4 py-3 text-slate-400 hover:bg-slate-800 rounded-xl transition-all">
            <.icon name="hero-cog-6-tooth" class="w-5 h-5" />
            <span>환경 설정</span>
          </a>
        </nav>

        <div class="p-6 border-t border-slate-800 bg-slate-900/50">
          <div class="text-xs text-slate-500 mb-1">총 자산</div>
          <div class="text-lg font-bold">₩{Number.to_delimited(@total_asset)}</div>
          <div class="flex items-center gap-2 mt-2">
            <span class="text-xs px-2 py-0.5 bg-rose-500/10 text-rose-500 rounded-full">
              +{Number.to_delimited(@daily_profit)} ({(@daily_rate)}%)
            </span>
          </div>
        </div>
      </aside>

      <%!-- 메인 콘텐츠 --%>
      <main class="flex-1 flex flex-col overflow-hidden">
        <header class="h-16 border-b border-slate-800 flex items-center justify-between px-8 bg-slate-950/50 backdrop-blur-xl">
          <div class="flex items-center gap-4">
            <h2 class="text-lg font-semibold text-slate-100">실시간 잔고 현황</h2>
            <div class="h-4 w-[1px] bg-slate-800"></div>
            <div class="text-sm text-slate-500">종목을 클릭하여 상세 설정을 변경하세요.</div>
          </div>
        </header>

        <div class="flex-1 overflow-auto p-8">
          <div class="bg-slate-900/50 border border-slate-800 rounded-2xl overflow-hidden shadow-2xl">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-slate-800/50 text-slate-400 text-xs uppercase tracking-wider">
                  <th class="px-6 py-4 font-semibold">종목명</th>
                  <th class="px-6 py-4 font-semibold text-right">현재가</th>
                  <th class="px-6 py-4 font-semibold text-right">수익률</th>
                  <th class="px-6 py-4 font-semibold text-right">보유/평단</th>
                  <th class="px-6 py-4 font-semibold">분할 매수 상태 (차수)</th>
                </tr>
              </thead>
              <tbody id="stock-list" phx-update="stream">
                <tr :for={{id, stock} <- @streams.stocks} id={id} 
                    phx-click="select_stock" phx-value-id={stock.id}
                    class="border-b border-slate-800/50 hover:bg-indigo-500/10 transition-colors group cursor-pointer">
                  <td class="px-6 py-5">
                    <div class="font-bold text-slate-100 group-hover:text-indigo-400 transition-colors">{stock.name}</div>
                    <div class="text-xs text-slate-500 font-mono">{stock.id}</div>
                  </td>
                  <td class={[
                    "px-6 py-5 text-right font-mono font-medium",
                    stock.change > 0 && "text-rose-500",
                    stock.change < 0 && "text-blue-500"
                  ]}>
                    {Number.to_delimited(stock.price)}
                  </td>
                  <td class={[
                    "px-6 py-5 text-right font-bold",
                    stock.change > 0 && "text-rose-500",
                    stock.change < 0 && "text-blue-500"
                  ]}>
                    {if stock.change > 0, do: "+", else: ""}{stock.change}%
                  </td>
                  <td class="px-6 py-5 text-right">
                    <div class="text-slate-200">{stock.qty}주</div>
                    <div class="text-xs text-slate-500 font-mono">@{Number.to_delimited(stock.avg_price)}</div>
                  </td>
                  <td class="px-6 py-5">
                    <div class="flex gap-1.5">
                      <%= for i <- 1..7 do %>
                        <div class={[
                          "w-2.5 h-2.5 rounded-full border border-slate-700",
                          i <= stock.level && "bg-indigo-500 shadow-[0_0_8px_rgba(99,102,241,0.5)] border-indigo-400",
                          i > stock.level && "bg-slate-800"
                        ]}></div>
                      <% end %>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>
    """
  end
end

defmodule Number do
  def to_delimited(number) do
    number
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.join(",")
    |> String.reverse()
  end
end
