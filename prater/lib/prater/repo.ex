defmodule Prater.Repo do
  use Ecto.Repo,
    otp_app: :prater,
    adapter: Ecto.Adapters.Postgres
end
