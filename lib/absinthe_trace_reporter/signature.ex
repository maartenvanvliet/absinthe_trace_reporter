defmodule AbsintheTraceReporter.Signature do
  alias Absinthe.Language

  def build(operations) when is_list(operations) do
    "# -\n{" <> (operations |> Enum.map_join("\n", &operation/1)) <> "}"
  end

  def operation(%Absinthe.Blueprint.Document.Operation{selections: selections} = operation) do
    from_selections(selections)
  end

  def from_selections([]), do: []

  def from_selections(selections) when is_list(selections) do
    # from_selection(selection)
    selections
    |> Enum.map(fn selection -> from_selection(selection) end)
  end

  def from_selection(%Absinthe.Blueprint.Document.Field{name: name, selections: []}) do
    "#{name}"
  end

  def from_selection(%Absinthe.Blueprint.Document.Field{name: name, selections: selections}) do
    "#{name}{" <> (from_selections(selections) |> Enum.join(" ")) <> "}"
  end

  def from_selection(%Absinthe.Blueprint.Document.Fragment.Spread{name: name}) do
    "#{name}"
  end
end
