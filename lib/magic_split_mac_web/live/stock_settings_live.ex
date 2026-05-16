defmodule MagicSplitMacWeb.StockSettingsLive do
  use MagicSplitMacWeb, :live_view

  @stocks [
    %{id: "005930", name: "삼성전자", price: 72500, change: 1.2, qty: 100, avg_price: 71000, level: 2},
    %{id: "000660", name: "SK하이닉스", price: 115000, change: -0.8, qty: 50, avg_price: 116500, level: 3},
    %{id: "035420", name: "NAVER", price: 195000, change: 0.5, qty: 30, avg_price: 192000, level: 1},
    %{id: "005380", name: "현대차", price: 205000, change: -1.5, qty: 20, avg_price: 210000, level: 4},
    %{id: "035720", name: "카카오", price: 48500, change: 2.1, qty: 200, avg_price: 47000, level: 1}
  ]

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    # ID로 종목 찾기
    stock = Enum.find(@stocks, fn s -> s.id == id end)

    if stock do
      {:ok, 
       socket 
       |> assign(:page_title, "#{stock.name} 설정 - MagicSplit")
       |> assign(:stock, stock)}
    else
      {:ok, push_navigate(socket, to: ~p"/dashboard")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-slate-950 text-slate-200 font-sans flex flex-col">
      <%!-- 헤더 영역 --%>
      <header class="h-20 border-b border-slate-800 bg-slate-900/50 backdrop-blur-xl sticky top-0 z-10 flex items-center justify-between px-10">
        <div class="flex items-center gap-6">
          <button phx-click={JS.navigate(~p"/dashboard")} class="group p-2 hover:bg-slate-800 rounded-full transition-all">
            <.icon name="hero-arrow-left" class="w-6 h-6 text-slate-500 group-hover:text-slate-100" />
          </button>
          <div class="flex flex-col">
            <h1 class="text-2xl font-bold text-slate-100 italic">
              {@stock.name} <span class="text-base font-mono font-normal text-slate-500 ml-2">{@stock.id}</span>
            </h1>
            <div class="flex items-center gap-2">
              <span class="w-2 h-2 bg-emerald-500 rounded-full shadow-[0_0_8px_rgba(16,185,129,0.5)]"></span>
              <span class="text-[11px] text-emerald-500 font-bold uppercase tracking-widest">자동매매 시스템 작동 중</span>
            </div>
          </div>
        </div>

        <div class="flex gap-4">
          <button phx-click={JS.navigate(~p"/dashboard")} class="px-6 py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-2xl text-sm font-bold transition-all">취소</button>
          <button phx-click={JS.navigate(~p"/dashboard")} class="px-8 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white rounded-2xl text-sm font-bold shadow-lg shadow-indigo-900/40 transition-all active:scale-95">설정 저장</button>
        </div>
      </header>

      <%!-- 설정 본문 영역 --%>
      <main class="flex-1 overflow-auto p-10">
        <div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-10">
          
          <%!-- 왼쪽: 매수 전략 카드 --%>
          <section class="space-y-6">
            <div class="bg-slate-900 border border-rose-500/20 rounded-[2.5rem] p-8 shadow-2xl">
              <div class="flex items-center justify-between mb-8 border-b border-rose-500/10 pb-6">
                <h2 class="text-rose-500 text-xl font-bold flex items-center gap-3">
                  <.icon name="hero-arrow-down-circle" class="w-8 h-8" />
                  자동매수 (분할매수)
                </h2>
                <div class="flex items-center gap-3">
                  <span class="text-xs text-slate-500">주문방식:</span>
                  <select class="bg-slate-800 border-none rounded-xl text-xs p-2 outline-none cursor-pointer">
                    <option>시장가</option>
                    <option>지정가</option>
                  </select>
                </div>
              </div>

              <div class="space-y-4">
                <%= for i <- 1..10 do %>
                  <div class="flex items-center gap-5 bg-slate-800/40 p-4 rounded-3xl border border-slate-800 hover:border-rose-500/30 transition-all group">
                    <span class="w-12 text-sm font-black text-slate-700 group-hover:text-rose-500/50 transition-colors italic">{i}차</span>
                    <div class="flex-1 flex items-center gap-3">
                      <span class="text-xs text-slate-500">하락시</span>
                      <input type="text" class="w-24 bg-slate-950 border-slate-700 rounded-xl p-2.5 text-right text-base text-rose-400 font-mono outline-none focus:ring-2 focus:ring-rose-500/50" value="-1.5">
                      <span class="text-xs text-slate-500">%</span>
                    </div>
                    <div class="flex-1 flex items-center gap-3 text-center">
                      <input type="text" class="w-36 bg-slate-950 border-slate-700 rounded-xl p-2.5 text-right text-base text-slate-100 font-mono outline-none focus:ring-2 focus:ring-rose-500/50" value="1,000,000">
                      <span class="text-xs text-slate-500">원</span>
                    </div>
                    <div class={["w-14 text-center px-2 py-1 rounded-full text-[10px] font-bold uppercase tracking-tighter", if(i <= @stock.level, do: "bg-rose-500/20 text-rose-500", else: "bg-slate-800 text-slate-600")]}>
                      {if i <= @stock.level, do: "완료", else: "대기"}
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          </section>

          <%!-- 오른쪽: 매도 전략 및 추가 옵션 --%>
          <section class="space-y-10">
            <div class="bg-slate-900 border border-blue-500/20 rounded-[2.5rem] p-8 shadow-2xl">
              <div class="flex items-center justify-between mb-8 border-b border-blue-500/10 pb-6">
                <h2 class="text-blue-500 text-xl font-bold flex items-center gap-3">
                  <.icon name="hero-arrow-up-circle" class="w-8 h-8" />
                  자동매도 (이익청산)
                </h2>
                <div class="text-xs text-slate-500 italic">각 차수별 개별 익절 대응</div>
              </div>

              <div class="space-y-4">
                <%= for i <- 1..10 do %>
                  <div class="flex items-center gap-5 bg-slate-800/40 p-4 rounded-3xl border border-slate-800 hover:border-blue-500/30 transition-all group">
                    <span class="w-12 text-sm font-black text-slate-700 group-hover:text-blue-500/50 transition-colors italic">{i}차</span>
                    <div class="flex-1 flex items-center gap-3">
                      <span class="text-xs text-slate-500">수익시</span>
                      <input type="text" class="w-24 bg-slate-950 border-slate-700 rounded-xl p-2.5 text-right text-base text-blue-400 font-mono outline-none focus:ring-2 focus:ring-blue-500/50" value="1.1">
                      <span class="text-xs text-slate-500">%</span>
                    </div>
                    <div class="flex-1 text-xs text-slate-600 font-light italic">
                      진입 물량 전량 매도
                    </div>
                  </div>
                <% end %>
              </div>
            </div>

            <%!-- 추가 프리미엄 옵션 카드 --%>
            <div class="bg-gradient-to-br from-indigo-900/20 to-slate-900 border border-indigo-500/20 rounded-[2.5rem] p-8 shadow-2xl relative overflow-hidden group">
              <div class="absolute -right-10 -top-10 w-40 h-40 bg-indigo-500/10 rounded-full blur-3xl group-hover:bg-indigo-500/20 transition-all"></div>
              <h3 class="text-indigo-400 text-lg font-bold flex items-center gap-3 mb-6">
                <.icon name="hero-sparkles" class="w-6 h-6" />
                수익부스터 (Revenue Booster)
              </h3>
              <div class="flex items-start gap-4 p-5 bg-indigo-500/5 rounded-3xl border border-indigo-500/10">
                <input type="checkbox" id="booster" checked class="mt-1.5 w-5 h-5 rounded-lg border-slate-700 bg-slate-950 text-indigo-500 focus:ring-offset-slate-900 transition-all">
                <div class="flex flex-col">
                  <label for="booster" class="text-base font-bold text-slate-200 cursor-pointer">매도 체결 후 하락 시 재매수 활성화</label>
                  <p class="text-sm text-slate-500 mt-2 leading-relaxed">
                    목표가 도달로 이익 실현 후, 주가가 다시 하락하여 원위치에 오면 지체 없이 해당 차수를 재매수합니다. 
                    <span class="text-indigo-400 block mt-1">※ 무한 반복 매매를 통해 복리 효과를 극대화합니다.</span>
                  </p>
                </div>
              </div>
            </div>
          </section>

        </div>
      </main>
    </div>
    """
  end
end
