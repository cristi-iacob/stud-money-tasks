defmodule TaskManagement.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:tasks, [:bag, :public, :named_table])

    children = [
      # Starts a worker by calling: TaskManagement.Worker.start_link(arg)
      # {taskManagement.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: api_port]},
      {Mongo, [name: :mongo, database: db, pool_size: 2, hostname: db_host]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskManagement.Supervisor]
    Supervisor.start_link(children, opts)

    #Api.Service.Publisher.start_link
  end

  defp api_port, do: Application.get_env(:task_management, :api_port)
  defp db, do: Application.get_env(:task_management, :db_db)
  defp db_host, do: Application.get_env(:task_management, :db_host)
end
