defmodule AbsintheTraceReporter.Fixtures.DeepMultiList do
  def resolvers do
    [
      %{
        duration: 26000,
        fieldName: "books",
        meta: nil,
        parentType: "RootQueryType",
        path: ["books"],
        returnType: "[Book]",
        startOffset: 385_000
      },
      %{
        duration: 39000,
        fieldName: "publishers",
        meta: nil,
        parentType: "Book",
        path: ["books", 0, "publishers"],
        returnType: "[Publisher]",
        startOffset: 434_000
      },
      %{
        duration: 8000,
        fieldName: "name",
        meta: nil,
        parentType: "Publisher",
        path: ["books", 0, "publishers", 0, "name"],
        returnType: "String",
        startOffset: 495_000
      },
      %{
        duration: 34000,
        fieldName: "publishers",
        meta: nil,
        parentType: "Book",
        path: ["books", 1, "publishers"],
        returnType: "[Publisher]",
        startOffset: 520_000
      },
      %{
        duration: 5000,
        fieldName: "name",
        meta: nil,
        parentType: "Publisher",
        path: ["books", 1, "publishers", 0, "name"],
        returnType: "String",
        startOffset: 562_000
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
                  child: [
                    %Mdg.Engine.Proto.Trace.Node{
                      cache_policy: nil,
                      child: [
                        %Mdg.Engine.Proto.Trace.Node{
                          cache_policy: nil,
                          child: [],
                          end_time: 503_000,
                          error: [],
                          id: {:field_name, "name"},
                          parent_type: "Publisher",
                          start_time: 495_000,
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
                  end_time: 473_000,
                  error: [],
                  id: {:field_name, "publishers"},
                  parent_type: "Book",
                  start_time: 434_000,
                  type: "[Publisher]"
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
                  child: [
                    %Mdg.Engine.Proto.Trace.Node{
                      cache_policy: nil,
                      child: [
                        %Mdg.Engine.Proto.Trace.Node{
                          cache_policy: nil,
                          child: [],
                          end_time: 567_000,
                          error: [],
                          id: {:field_name, "name"},
                          parent_type: "Publisher",
                          start_time: 562_000,
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
                  end_time: 554_000,
                  error: [],
                  id: {:field_name, "publishers"},
                  parent_type: "Book",
                  start_time: 520_000,
                  type: "[Publisher]"
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
          end_time: 411_000,
          error: [],
          id: {:field_name, "books"},
          parent_type: "RootQueryType",
          start_time: 385_000,
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
