defmodule AbsintheTraceReporter.Fixtures.DeepNode do
  def resolvers do
    [
      %{
        duration: 28000,
        fieldName: "book",
        meta: nil,
        parentType: "RootQueryType",
        path: ["book"],
        returnType: "Book",
        startOffset: 376_000
      },
      %{
        duration: 18000,
        fieldName: "publisher",
        meta: nil,
        parentType: "Book",
        path: ["book", "publisher"],
        returnType: "Publisher",
        startOffset: 423_000
      },
      %{
        duration: 15_518_000,
        fieldName: "name",
        meta: nil,
        parentType: "Publisher",
        path: ["book", "publisher", "name"],
        returnType: "String",
        startOffset: 452_000
      }
    ]
  end

  def trace_result do
    %Mdg.Engine.Proto.Trace.Node{
      cache_policy: nil,
      end_time: 0,
      error: [],
      id: {:field_name, "RootQueryType"},
      parent_type: "",
      start_time: 0,
      type: "",
      child: [
        %Mdg.Engine.Proto.Trace.Node{
          cache_policy: nil,
          error: [],
          parent_type: "RootQueryType",
          child: [
            %Mdg.Engine.Proto.Trace.Node{
              cache_policy: nil,
              child: [
                %Mdg.Engine.Proto.Trace.Node{
                  cache_policy: nil,
                  child: [],
                  end_time: 15_970_000,
                  error: [],
                  id: {:field_name, "name"},
                  parent_type: "Publisher",
                  start_time: 452_000,
                  type: "String"
                }
              ],
              end_time: 441_000,
              error: [],
              id: {:field_name, "publisher"},
              parent_type: "Book",
              start_time: 423_000,
              type: "Publisher"
            }
          ],
          end_time: 404_000,
          id: {:field_name, "book"},
          start_time: 376_000,
          type: "Book"
        }
      ]
    }
  end
end
