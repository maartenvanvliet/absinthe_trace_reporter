defmodule AbsintheTraceReporter.Fixtures.DeepSimpleList do
  def resolvers do
    [
      %{
        duration: 40000,
        fieldName: "book",
        meta: nil,
        parentType: "RootQueryType",
        path: ["book"],
        returnType: "Book",
        startOffset: 740_000
      },
      %{
        duration: 32000,
        fieldName: "publishers",
        meta: nil,
        parentType: "Book",
        path: ["book", "publishers"],
        returnType: "[Publisher]",
        startOffset: 844_000
      },
      %{
        duration: 12000,
        fieldName: "name",
        meta: nil,
        parentType: "Publisher",
        path: ["book", "publishers", 0, "name"],
        returnType: "String",
        startOffset: 935_000
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
                  child: [
                    %Mdg.Engine.Proto.Trace.Node{
                      cache_policy: nil,
                      child: [],
                      end_time: 947_000,
                      error: [],
                      id: {:field_name, "name"},
                      parent_type: "Publisher",
                      start_time: 935_000,
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
              end_time: 876_000,
              error: [],
              id: {:field_name, "publishers"},
              parent_type: "Book",
              start_time: 844_000,
              type: "[Publisher]"
            }
          ],
          end_time: 780_000,
          id: {:field_name, "book"},
          start_time: 740_000,
          type: "Book"
        }
      ]
    }
  end
end
