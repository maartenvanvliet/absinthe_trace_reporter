defmodule TreeTest do
  use ExUnit.Case

  alias AbsintheTraceReporter.TraceProvider.Engine

  alias AbsintheTraceReporter.Fixtures.{
    SimpleNode,
    SimpleNestedNode,
    SimpleList,
    MultiList,
    DeepNode,
    DeepSimpleList,
    DeepMultiList
  }

  @tag :only
  test "simple node" do
    resolvers = SimpleNode.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == SimpleNode.trace_result()
  end

  # @tag :only
  test "simple nested node" do
    resolvers = SimpleNestedNode.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == SimpleNestedNode.trace_result()
  end

  # @tag :only
  test "simple list" do
    resolvers = SimpleList.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == SimpleList.trace_result()
  end

  test "multi list" do
    resolvers = MultiList.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == MultiList.trace_result()
  end

  test "deep node" do
    resolvers = DeepNode.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == DeepNode.trace_result()
  end

  test "deep simple list" do
    resolvers = DeepSimpleList.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == DeepSimpleList.trace_result()
  end

  test "deep nestedlist node test" do
    resolvers = DeepMultiList.resolvers()

    result = Engine.build_trace_tree(resolvers)

    assert result == DeepMultiList.trace_result()
  end
end
