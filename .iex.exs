### Courtesy https://gist.github.com/DaniruKun/ccbaad8720c203fd6d86a39722c63c51

IO.puts("Using .iex.exs file loaded from #{__DIR__}/.iex.exs")

defmodule Util do
  def atom_status do
    limit = :erlang.system_info(:atom_limit)
    count = :erlang.system_info(:atom_count)

    IO.puts("Currently using #{count} / #{limit} atoms")
  end

  def cls, do: IO.puts("\ec")

  def raw(any, label \\ "iex") do
    IO.inspect(any,
      label: label,
      pretty: true,
      limit: :infinity,
      structs: false,
      syntax_colors: [
        number: :yellow,
        atom: :cyan,
        string: :green,
        nil: :magenta,
        boolean: :magenta
      ],
      width: 0
    )
  end

  @doc ~S"""
  Update the IEx configuration using the func given as argument. The function
  is passed the current configuration and should return a new configuration
  that will be passed to IEx.configuration/0.

  Example:


  iex(3)> update_iex_config(fn conf ->
  ...(3)>   Keyword.update!(
  ...(3)>     conf,
  ...(3)>     :inspect,
  ...(3)>     fn inspect_ ->
  ...(3)>       Keyword.put(inspect_, :pretty, true)
  ...(3)>       |> Keyword.delete(:charlists)
  ...(3)>     end
  ...(3)>   )
  ...(3)> end)
  """
  def update_iex_config(func) do
    new_config = func.(IEx.configuration())
    :ok = IEx.configure(new_config)
    new_config
  end
end

defmodule :_util do
  defdelegate exit(), to: System, as: :halt
  defdelegate q(), to: System, as: :halt
  defdelegate cls(), to: Util, as: :cls
  defdelegate restart(), to: System, as: :restart
  defdelegate rs(), to: System, as: :restart
  defdelegate raw(any), to: Util, as: :raw
  defdelegate update_iex_config(func), to: Util, as: :update_iex_config
end

import :_util

# https://stratus3d.com/blog/2023/10/15/show-all-telemetry-events-in-erlang-and-elixir/
defmodule TelemetryHelper do
  @moduledoc """
  Helper functions for seeing all telemetry events.
  Only for use in development.
  """

  @doc """
  attach_all/0 prints out all telemetry events received by default.
  Optionally, you can specify a handler function that will be invoked
  with the same three arguments that the `:telemetry.execute/3` and
  `:telemetry.span/3` functions were invoked with.
  """
  def attach_all(function \\ &default_handler_fn/3) do
    # Start the tracer
    :dbg.start()

    # Create tracer process with a function that pattern matches out the three arguments the telemetry calls are made with.
    :dbg.tracer(
      :process,
      {fn
         {_, _, _, {_mod, :execute, [name, measurement, metadata]}}, _state ->
           function.(name, metadata, measurement)

         {_, _, _, {_mod, :span, [name, metadata, span_fun]}}, _state ->
           function.(name, metadata, span_fun)
       end, nil}
    )

    # Trace all processes
    :dbg.p(:all, :c)

    # Trace calls to the functions used to emit telemetry events
    :dbg.tp(:telemetry, :execute, 3, [])
    :dbg.tp(:telemetry, :span, 3, [])
  end

  def stop do
    # Stop tracer
    :dbg.stop()
  end

  defp default_handler_fn(name, metadata, measure_or_fun) do
    # Print out telemetry info
    IO.puts(
      "Telemetry event:#{inspect(name)}\nwith #{inspect(measure_or_fun)} and #{inspect(metadata)}"
    )
  end
end

# Examples usages:
# TelemetryHelper.attach_all()
# TelemetryHelper.stop()

# Type below to get all options to inspect
# h Inspect.Opts
IEx.configure(
  inspect: [
    # charlists: :as_charlists,
    # charlists: :as_lists,
    charlists: :infer,
    limit: :infinity
  ],
  history_size: 1_000_000
)
