defmodule TodoLiveWeb.TaskLive.Summary do
  use TodoLiveWeb, :live_view

  alias TodoLive.Tasks
  alias TodoLive.Tasks.Task

  def render(assigns) do
    ~H"""
    <.header>
      Your Todo
    </.header>
    <hr>

    <h2 class="text-xl mt-4">
      New Task
    </h2>
    <hr>
    <.simple_form
      for={@form}
      phx-change="validate_task"
      phx-submit="save_task"
      class="border rounded-lg px-4 py-2"
    >
      <.input field={@form[:title]} type="text" label="Title" />
      <.input field={@form[:date]} type="date" label="Date" />
      <:actions>
        <.button phx-disabled-with="Adding...">Add Task</.button>
      </:actions>
    </.simple_form>

    <h2 class="text-xl mt-4">
      In progress or prior to start
    </h2>
    <hr>
    <div :for={task <- @tasks} class="mt-2" :if={task.completed == false}>
      <a>
        <form phx-change="complete_task">
          <input type="checkbox">
          <input type="hidden" name="task_id" value={task.id}>
        </form>
        <div><%= task.title %></div>
        <div><%= task.date %></div>
        <div phx-click="delete_task" phx-value-task_id={task.id}> Delete </div>
      </a>
    </div>

    <h2 class="text-xl mt-4">
      Completed
    </h2>
    <hr>
    <div :for={task <- @tasks} class="mt-2" :if={task.completed == true}>
      <a>
        <form phx-change="uncomplete_task">
          <input type="checkbox" checked>
          <input type="hidden" name="task_id" value={task.id}>
        </form>
        <div><%= task.title %></div>
        <div><%= task.date %></div>
        <div phx-click="delete_task" phx-value-task_id={task.id}> Delete </div>
      </a>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:tasks, Tasks.list_tasks_by_account_id(socket.assigns.current_account.id))
      |> assign_form(Tasks.change_task(%Task{}))
      |> assign(:page_title, "Todo")

    {:ok, socket}
  end

  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    socket =
      case Tasks.delete_task(Tasks.get_task!(task_id)) do
        {:ok, _task} ->
          assign_task_when_deleted(socket, socket.assigns.live_action)

        {:error, _cs} ->
          put_flash(socket, :error, "Could not delete task.")
      end

    {:noreply, socket}
  end

  def handle_event("complete_task", %{"task_id" => task_id}, socket) do
    task = Tasks.get_task!(task_id)
    socket =
      case Tasks.update_task(task, %{completed: true}) do
        {:ok, _task} ->
          tasks = Tasks.list_tasks_by_account_id(socket.assigns.current_account.id)
          socket
          |> assign(:tasks, tasks)
          |> put_flash(:info, "Task updated successfully.")

        {:error, _cs} ->
          put_flash(socket, :error, "Could not update task.")
      end
    {:noreply, socket}
  end

  def handle_event("uncomplete_task", %{"task_id" => task_id}, socket) do
    task = Tasks.get_task!(task_id)
    socket =
      case Tasks.update_task(task, %{completed: false}) do
        {:ok, _task} ->
          tasks = Tasks.list_tasks_by_account_id(socket.assigns.current_account.id)
          socket
          |> assign(:tasks, tasks)
          |> put_flash(:info, "Task updated successfully.")

        {:error, _cs} ->
          put_flash(socket, :error, "Could not update task.")
      end
    {:noreply, socket}
  end

  defp assign_task_when_deleted(socket, :summary) do
    tasks = Tasks.list_tasks_by_account_id(socket.assigns.current_account.id)
    socket
    |> assign(:tasks, tasks)
    |> put_flash(:info, "Task deleted successfully.")
  end

  # FORM
  def handle_event("validate_task", %{"task" => params}, socket) do
    {:noreply, assign_form(socket, Tasks.change_task(%Task{}, params))}
  end

  def handle_event("save_task", %{"task" => params}, socket) do
    params = Map.merge(params, %{"account_id" => socket.assigns.current_account.id})
    socket =
      case Tasks.create_task(params) do
        {:ok, _task} ->
          socket
          |> put_flash(:info, "Created task successfully.")
          |> assign(:tasks, Tasks.list_tasks_by_account_id(socket.assigns.current_account.id))
          |> assign_form(Tasks.change_task(%Task{}))

        {:error, cs} ->
          assign_form(socket, cs)
      end

    {:noreply, socket}
  end

  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs))
  end
  #
end
