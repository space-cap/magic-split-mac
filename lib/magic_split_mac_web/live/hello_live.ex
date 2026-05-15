defmodule MagicSplitMacWeb.HelloLive do
  use MagicSplitMacWeb, :live_view

  def mount(_params, _session, socket) do
    # 페이지가 처음 열릴 때 실행되는 함수입니다.
    # 여기에 초기 데이터를 넣을 수 있어요.
    {:ok, assign(socket, :message, "Hello World from New Page!")}
  end

  def render(assigns) do
    # 화면에 그려질 HTML 내용입니다.
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="flex flex-col items-center justify-center min-h-[60vh] text-center">
        <div class="p-10 bg-base-200 rounded-3xl shadow-xl border border-primary/20">
          <h1 class="text-6xl font-black text-primary mb-6 animate-pulse">
            {@message}
          </h1>
          <p class="text-xl text-base-content/70 mb-8">
            축하합니다! 직접 만든 새로운 페이지가 성공적으로 작동하고 있어요. 🥳
          </p>
          <.link
            navigate={~p"/"}
            class="btn btn-primary btn-lg"
          >
            홈으로 돌아가기
          </link>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
