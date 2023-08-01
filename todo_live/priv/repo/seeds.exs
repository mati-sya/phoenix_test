# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoLive.Repo.insert!(%TodoLive.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TodoLive.Repo
alias TodoLive.Accounts.Account
alias TodoLive.Tasks

params = [
  {"user01@sample.com", "user01999"},
  {"user02@sample.com", "user02999"},
  {"user03@sample.com", "user03999"}
]

[_a01, _a02, _a03] =
  Enum.map(params, fn {email, password} ->
    Repo.insert!(%Account{
      email: email,
      hashed_password: Pbkdf2.hash_pwd_salt(password),
      confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    })
  end)

Tasks.create_task(%{
  title: "買い物",
  account_id: 1,
  date: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})

Tasks.create_task(%{
  title: "洗濯",
  account_id: 1,
  date: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})

Tasks.create_task(%{
  title: "勉強",
  account_id: 1,
  completed: true,
  date: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})
