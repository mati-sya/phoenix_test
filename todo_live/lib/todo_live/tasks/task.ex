defmodule TodoLive.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoLive.Accounts.Account

  schema "tasks" do
    field :completed, :boolean, default: false
    field :date, :date
    field :title, :string
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :date, :completed, :account_id])
    |> validate_required([:title, :date, :completed])
  end
end
