defmodule AbsintheTraceReporter.Fixtures.SimpleList do
  def resolvers do
    [
      %{
        duration: 75740,
        fieldName: "books",
        meta: nil,
        parentType: "RootQueryType",
        path: ["books"],
        returnType: "[Book]",
        startOffset: 668_460
      },
      %{
        duration: 41400,
        fieldName: "title",
        meta: nil,
        parentType: "Book",
        path: ["books", 0, "title"],
        returnType: "String",
        startOffset: 827_000
      }
    ]
  end

  def trace_result do
    %Mdg.Engine.Proto.Trace.Node{
      cache_policy: nil,
      child: [
        %Mdg.Engine.Proto.Trace.Node{
          cache_policy: nil,
          child: [
            %Mdg.Engine.Proto.Trace.Node{
              cache_policy: nil,
              child: [
                %Mdg.Engine.Proto.Trace.Node{
                  cache_policy: nil,
                  child: [],
                  end_time: 868_400,
                  error: [],
                  id: {:field_name, "title"},
                  parent_type: "Book",
                  start_time: 827_000,
                  type: "String"
                }
              ],
              end_time: 0,
              error: [],
              id: {:index, 0},
              parent_type: "",
              start_time: 0,
              type: ""
            }
          ],
          end_time: 744_200,
          error: [],
          id: {:field_name, "books"},
          parent_type: "RootQueryType",
          start_time: 668_460,
          type: "[Book]"
        }
      ],
      end_time: 0,
      error: [],
      id: {:field_name, "RootQueryType"},
      parent_type: "",
      start_time: 0,
      type: ""
    }
  end
end
