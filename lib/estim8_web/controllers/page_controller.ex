defmodule Estim8Web.PageController do
  use Estim8Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, room_id: Estim8Web.Utils.generate_room_id())
  end
end
