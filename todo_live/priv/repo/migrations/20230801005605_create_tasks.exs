defmodule TodoLive.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :date, :date
      add :completed, :boolean, default: false, null: false
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:account_id])
  end
end
