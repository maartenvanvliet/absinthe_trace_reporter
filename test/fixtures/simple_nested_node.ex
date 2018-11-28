defmodule AbsintheTraceReporter.Fixtures.SimpleNestedNode do
  def resolvers do
    [
      %{
        duration: 338_528_000,
        fieldName: "book",
        meta: nil,
        parentType: "RootQueryType",
        path: ["book"],
        returnType: "Book",
        startOffset: 336_000
      },
      %{
        duration: 28000,
        fieldName: "author",
        meta: nil,
        parentType: "Book",
        path: ["book", "author"],
        returnType: "String",
        startOffset: 338_974_000
      },
      %{
        duration: 12000,
        fieldName: "title",
        meta: nil,
        parentType: "Book",
        path: ["book", "title"],
        returnType: "String",
        startOffset: 339_018_000
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
              child: [],
              end_time: 339_002_000,
              error: [],
              id: {:field_name, "author"},
              parent_type: "Book",
              start_time: 338_974_000,
              type: "String"
            },
            %Mdg.Engine.Proto.Trace.Node{
              cache_policy: nil,
              child: [],
              end_time: 339_030_000,
              error: [],
              id: {:field_name, "title"},
              parent_type: "Book",
              start_time: 339_018_000,
              type: "String"
            }
          ],
          end_time: 338_864_000,
          error: [],
          id: {:field_name, "book"},
          parent_type: "RootQueryType",
          start_time: 336_000,
          type: "Book"
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
