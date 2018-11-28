defmodule AbsintheTraceReporter.TraceReportProvider do
  @callback build_trace_report([any]) :: any
end
