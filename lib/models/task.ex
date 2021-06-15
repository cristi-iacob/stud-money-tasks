defmodule Api.Models.Task do
  @db_name Application.get_env(:task_management, :db_db)
  @db_table "tasks"

  alias Api.Helpers.MapHelper

  use Api.Models.Base
  #INFO: mongo also has an internal ID
  defstruct [
    :id,
    :owner_id,
    :accepted_user_id,
    :date,
    :reward,
    :location,
    :description,
    :created_at,
    :updated_at
  ]


end
