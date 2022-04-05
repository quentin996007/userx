defmodule Userx.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :userx

  def create_database do
    :ok = create_database(Userx.Repo)
  end

  defp create_database(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        IO.puts("create database #{inspect(repo)} (#{Keyword.get(repo.config, :database)})")

      {:error, :already_up} ->
        IO.puts(
          "already created database #{inspect(repo)} (#{Keyword.get(repo.config, :database)})"
        )

      {:error, term} ->
        IO.puts("error when create database #{inspect(repo)}! #{inspect(term)}")
        {:error, term}
    end
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
