defmodule TodoLiveWeb.TaskLive.Summary do
  use TodoLiveWeb, :live_view

  alias TodoLive.Tasks

  def render(assigns) do
    ~H"""
    <.header>
      Your Todo
    </.header>

    <h2 class="text-xl mt-4">
      New Task
    </h2>

    <h2 class="text-xl mt-4">
      In progress or prior to start
    </h2>
    <div :for={task <- @tasks} class="mt-2" :if={task.completed == false}>
      <a>
        <div><%= task.title %></div>
        <div><%= task.date %></div>
        <div phx-click="delete_task" phx-value-task_id={task.id}> Delete </div>
      </a>
    </div>

    <h2 class="text-xl mt-4">
      Completed
    </h2>
    <div :for={task <- @tasks} class="mt-2" :if={task.completed == true}>
      <a>
        <div><%= task.title %></div>
        <div><%= task.date %></div>
      </a>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:tasks, Tasks.list_tasks())
      |> assign(:page_title, "Todo")

    {:ok, socket}
  end

  def handle_event("delete_task", &{"task_id" => task_id}, socket) do
    socket =
      case Tasks.delete_task(Tasks.get_task!(task_id)) do
        {:ok, _article} ->
          assign_article_when_deleted(socket, socket.assigns.live_action)

        {:error, _cs} ->
          put_flash(socket, :error, "Could not delete task.")
      end
    {:noreply, socket}
  end

  # def handle_event("save", %{"task" => task_params}, socket) do
  #   case Tasks.create_task(task_params) do
  #     {:ok, user} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "task created")
  #        |> redirect(to: ~p"/tasks")}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end

  #
end
