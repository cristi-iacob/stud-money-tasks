defmodule Api.Views.TaskView do
  use JSONAPI.View

  def fields, do: [:id, :owner_id, :accepted_user_id, :date, :reward, :location, :description, :created_at, :updated_at]
  def type, do: "task"
  def relationships, do: []
end
