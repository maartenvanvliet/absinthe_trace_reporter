defmodule AbsintheTraceReporter.Fixtures.MultiList do
  def resolvers do
    [
      %{
        duration: 2_389_000,
        fieldName: "books",
        meta: nil,
        parentType: "RootQueryType",
        path: ["books"],
        returnType: "[Book]",
        startOffset: 98_196_000
      },
      %{
        duration: 1_267_000,
        fieldName: "title",
        meta: nil,
        parentType: "Book",
        path: ["books", 0, "title"],
        returnType: "String",
        startOffset: 100_610_000
      },
      %{
        duration: 10000,
        fieldName: "author",
        meta: nil,
        parentType: "Book",
        path: ["books", 0, "author"],
        returnType: "String",
        startOffset: 101_888_000
      },
      %{
        duration: 4000,
        fieldName: "title",
        meta: nil,
        parentType: "Book",
        path: ["books", 1, "title"],
        returnType: "String",
        startOffset: 101_917_000
      },
      %{
        duration: 3000,
        fieldName: "author",
        meta: nil,
        parentType: "Book",
        path: ["books", 1, "author"],
        returnType: "String",
        startOffset: 101_925_000
      }
    ]
  end

  def trace_result do
    tree = %Mdg.Engine.Proto.Trace.Node{
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
                  error: [],
                  id: {:field_name, "title"},
                  parent_type: "Book",
                  type: "String",
                  end_time: 101_877_000,
                  start_time: 100_610_000
                },
                %Mdg.Engine.Proto.Trace.Node{
                  cache_policy: nil,
                  child: [],
                  end_time: 101_898_000,
                  error: [],
                  id: {:field_name, "author"},
                  parent_type: "Book",
                  start_time: 101_888_000,
                  type: "String"
                }
              ],
              end_time: 0,
              error: [],
              id: {:index, 0},
              parent_type: "",
              start_time: 0,
              type: ""
            },
            %Mdg.Engine.Proto.Trace.Node{
              cache_policy: nil,
              child: [
                %Mdg.Engine.Proto.Trace.Node{
                  cache_policy: nil,
                  child: [],
                  error: [],
                  id: {:field_name, "title"},
                  parent_type: "Book",
                  type: "String",
                  end_time: 101_921_000,
                  start_time: 101_917_000
                },
                %Mdg.Engine.Proto.Trace.Node{
                  cache_policy: nil,
                  child: [],
                  end_time: 101_928_000,
                  error: [],
                  id: {:field_name, "author"},
                  parent_type: "Book",
                  start_time: 101_925_000,
                  type: "String"
                }
              ],
              end_time: 0,
              error: [],
              id: {:index, 1},
              parent_type: "",
              start_time: 0,
              type: ""
            }
          ],
          end_time: 98_196_000 + 2_389_000,
          error: [],
          id: {:field_name, "books"},
          parent_type: "RootQueryType",
          start_time: 98_196_000,
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
