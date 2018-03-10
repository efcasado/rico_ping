###========================================================================
### File: http.ex
###
###
### Author(s):
###   - Enrique Fernandez <efcasado@gmail.com>
###========================================================================
defmodule RicoPing.HTTP do
  ##== Preamble ===========================================================
  use Plug.Router
  
  plug :match
  plug :dispatch


  ##== API ================================================================
  def start_link() do
    port = Application :rico_ping, :port, 8080)
    Plug.Adapters.Cowboy2.http __MODULE__, [], port: port
  end


  ##== Auxiliary functions ================================================
  get "/ping" do
    res = RicoPing.ping
    res = inspect(res)
    send_resp(conn, 200, res)
  end
  
  match _ do
    send_resp(conn, 404, "Page Not Found!")
  end
  
end
