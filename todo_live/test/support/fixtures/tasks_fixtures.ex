defmodule TodoLive.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoLive.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        date: ~D[2023-07-31],
        title: "some title"
      })
      |> TodoLive.Tasks.create_task()

    task
  end
end
