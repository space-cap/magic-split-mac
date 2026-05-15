defmodule MagicSplitMacWeb.HelloLive do
  use MagicSplitMacWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :message, "Hello World from New Page!")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="flex flex-col items-center justify-center min-h-[60vh] text-center">
        <div class="p-10 bg-base-200 rounded-3xl shadow-xl border border-primary/20">
          <h1 class="text-6xl font-black text-primary mb-6 animate-bounce">
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
          </.link>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
