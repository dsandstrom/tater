defmodule Tater.ReleaseTasks do
  @moduledoc """
  Task for distillery releases
  """

  # TODO: add tests

  @start_apps [
    :postgrex,
    :ecto,
    :faker
  ]

  @apps [
    :tater
  ]

  @repos [
    Tater.Repo
  ]

  def migrate do
    setup()

    Enum.each(@apps, &run_migrations_for/1)

    teardown()
  end

  def seed do
    setup()

    Enum.each(@apps, &run_seeds_file_for/1)

    teardown()
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp setup do
    IO.puts "Loading tater.."
    # Load the code for tater, but don't start it
    :ok = Application.load(:tater)

    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for tater
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))
  end

  defp teardown do
    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Tater.Repo, migrations_path(app), :up, all: true)
  end

  defp run_seeds_file_for(app) do
    seed_script = seeds_path(app)
    if File.exists?(seed_script) do
      IO.puts "Running seed script for #{app}"
      Code.eval_file(seed_script)
    end
  end

  defp migrations_path(app), do:
    Path.join([priv_dir(app), "repo", "migrations"])

  defp seeds_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
