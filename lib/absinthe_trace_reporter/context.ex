defmodule AbsintheTraceReporter.Context do
  def init(opts), do: opts

  def call(conn, _) do
    info = build_trace_info(conn)
    conn = Absinthe.Plug.put_options(conn, %{a: 1})
    options = Map.merge(conn.private[:absinthe], info)
    conn = Absinthe.Plug.put_options(conn, context: options)
  end

  def build_trace_info(conn) do
    %{
      trace_info: %{
        path: conn.request_path,
        host: conn.host,
        method: conn.method
      }
    }
  end
end
