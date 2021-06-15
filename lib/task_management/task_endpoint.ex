defmodule Api.TaskEndpoint do
  use Plug.Router

  alias Api.Views.TaskView
  alias Api.Models.Task
  alias Api.Plugs.JsonTestPlug
  alias Api.Plugs.AuthPlug
  alias Api.Service.Publisher

  @api_port Application.get_env(:task_management, :api_port)
  @api_host Application.get_env(:task_management, :api_host)
  @api_scheme Application.get_env(:task_management, :api_scheme)

  @skip_token_verification %{jwt_skip: true}
  @routing_keys Application.get_env(:task_management, :routing_keys)

  plug :match
  plug AuthPlug
  plug :dispatch
  plug JsonTestPlug
  plug :encode_response

  defp encode_response(conn, _) do
    conn
    |> send_resp(
         conn.status,
         conn.assigns
         |> Map.get(:jsonapi, %{})
         |> Poison.encode!
       )
  end

  put "/update",
      private: %{
        jwt_skip: true,
        view: TaskView
      } do
    IO.puts("Update task requested")
    {id, owner_id, accepted_user_id, date, reward, location, description, created_at, updated_at} = {
      Map.get(conn.params, "id", nil),
      Map.get(conn.params, "owner_id", nil),
      Map.get(conn.params, "accepted_user_id", nil),
      Map.get(conn.params, "date", nil),
      Map.get(conn.params, "reward", nil),
      Map.get(conn.params, "location", nil),
      Map.get(conn.params, "description", nil),
      Map.get(conn.params, "created_at", nil),
      Map.get(conn.params, "updated_at", nil)
    }

    case Task.find(%{id: id}) do
      {:ok, entry} ->
        Task.delete(entry.id)

        case %Task {
          id: entry.id,
          accepted_user_id: accepted_user_id,
          date: date,
          reward: reward,
          location: location,
          description: description,
          updated_at: Timex.to_unix(Timex.now)
        }
        |> Task.save() do
          {:ok, createdEntry} ->
            conn
            |> put_status(200)
            |> assign(:jsonapi, createdEntry)

          :error ->
            conn
            |> put_status(500)
            |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
        end
    end
  end

  get "/",
        private: %{
          jwt_skip: true,
          view: TaskView
        } do

    IO.puts("Get all tasks requested...")
    {_, tasks} = Task.find_all(%{})
    conn
    |> put_status(200)
    |> assign(:jsonapi, tasks)
  end

  post "/create",
       private: %{
         jwt_skip: true,
         view: TaskView
       } do
    IO.puts("Create task request...")
    {:ok, service} = Api.Service.Auth.start_link
    {id, owner_id, accepted_user_id, date, reward, location, description, created_at, updated_at} = {
      Map.get(conn.params, "id", nil),
      Map.get(conn.params, "owner_id", nil),
      Map.get(conn.params, "accepted_user_id", nil),
      Map.get(conn.params, "date", nil),
      Map.get(conn.params, "reward", nil),
      Map.get(conn.params, "location", nil),
      Map.get(conn.params, "description", nil),
      Map.get(conn.params, "created_at", nil),
      Map.get(conn.params, "updated_at", nil)
    }

    id = UUID.uuid1()
    IO.puts("Create task request: #{id}, #{owner_id}, #{accepted_user_id}, #{date}, #{reward}, #{location}, #{description}, #{created_at}, #{updated_at}")
    cond do
      is_nil(reward) ->
        IO.puts("Reward missing")
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "reward must be present!"})

      is_nil(location) ->
        IO.puts("Location missing")
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "location must be present!"})

      is_nil(description) ->
        IO.puts("Description missing")
        conn
        |> put_status(400)
        |> assign(:jsonapi, %{error: "description must be present!"})

      true ->
        case %Task{id: id, owner_id: owner_id, accepted_user_id: accepted_user_id, date: date, reward: reward, location: location, description: description, created_at: created_at, updated_at: updated_at}
             |> Task.save do
          {:ok, created_entry} ->
            uri = "#{@api_scheme}://#{@api_host}:#{@api_port}#{conn.request_path}/"
            task = Task.find(id)
            task.update(created_entry.id, "location", "mongooo")

            conn
            |> put_resp_header("location", "#{uri}#{id}")
            |> put_status(201)
            |> assign(:jsonapi, created_entry)
          :error ->
            conn
            |> put_status(500)
            |> assign(:jsonapi, %{"error" => "An unexpected error happened"})
        end
    end
  end
end
