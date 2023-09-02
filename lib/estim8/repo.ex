defmodule Estim8.Repo do
  use Ecto.Repo,
    otp_app: :estim8,
    adapter: Ecto.Adapters.Postgres
end
