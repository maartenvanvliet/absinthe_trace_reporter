defmodule AbsintheTraceReporter.Trace do
  defstruct signature: nil, tracing: nil, info: nil, start_time: nil, end_time: nil

  def build(signature, trace, info) do
    %__MODULE__{
      signature: signature,
      tracing: trace,
      info: info,
      start_time: trace.startTime,
      end_time: trace.endTime
    }
  end
end
