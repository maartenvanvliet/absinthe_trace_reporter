defmodule Mdg.Engine.Proto.Trace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          start_time: Google.Protobuf.Timestamp.t(),
          end_time: Google.Protobuf.Timestamp.t(),
          duration_ns: non_neg_integer,
          origin_reported_start_time: Google.Protobuf.Timestamp.t(),
          origin_reported_end_time: Google.Protobuf.Timestamp.t(),
          origin_reported_duration_ns: non_neg_integer,
          signature: String.t(),
          legacy_signature_needs_resigning: String.t(),
          details: Mdg.Engine.Proto.Trace.Details.t(),
          client_name: String.t(),
          client_version: String.t(),
          client_address: String.t(),
          http: Mdg.Engine.Proto.Trace.HTTP.t(),
          cache_policy: Mdg.Engine.Proto.Trace.CachePolicy.t(),
          root: Mdg.Engine.Proto.Trace.Node.t(),
          full_query_cache_hit: boolean,
          persisted_query_hit: boolean,
          persisted_query_register: boolean
        }
  defstruct [
    :start_time,
    :end_time,
    :duration_ns,
    :origin_reported_start_time,
    :origin_reported_end_time,
    :origin_reported_duration_ns,
    :signature,
    :legacy_signature_needs_resigning,
    :details,
    :client_name,
    :client_version,
    :client_address,
    :http,
    :cache_policy,
    :root,
    :full_query_cache_hit,
    :persisted_query_hit,
    :persisted_query_register
  ]

  field(:start_time, 4, type: Google.Protobuf.Timestamp)
  field(:end_time, 3, type: Google.Protobuf.Timestamp)
  field(:duration_ns, 11, type: :uint64)
  field(:origin_reported_start_time, 15, type: Google.Protobuf.Timestamp)
  field(:origin_reported_end_time, 16, type: Google.Protobuf.Timestamp)
  field(:origin_reported_duration_ns, 17, type: :uint64)
  field(:signature, 19, type: :string)
  field(:legacy_signature_needs_resigning, 5, type: :string)
  field(:details, 6, type: Mdg.Engine.Proto.Trace.Details)
  field(:client_name, 7, type: :string)
  field(:client_version, 8, type: :string)
  field(:client_address, 9, type: :string)
  field(:http, 10, type: Mdg.Engine.Proto.Trace.HTTP)
  field(:cache_policy, 18, type: Mdg.Engine.Proto.Trace.CachePolicy)
  field(:root, 14, type: Mdg.Engine.Proto.Trace.Node)
  field(:full_query_cache_hit, 20, type: :bool)
  field(:persisted_query_hit, 21, type: :bool)
  field(:persisted_query_register, 22, type: :bool)
end

defmodule Mdg.Engine.Proto.Trace.CachePolicy do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          scope: integer,
          max_age_ns: integer
        }
  defstruct [:scope, :max_age_ns]

  field(:scope, 1, type: Mdg.Engine.Proto.Trace.CachePolicy.Scope, enum: true)
  field(:max_age_ns, 2, type: :int64)
end

defmodule Mdg.Engine.Proto.Trace.CachePolicy.Scope do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:UNKNOWN, 0)
  field(:PUBLIC, 1)
  field(:PRIVATE, 2)
end

defmodule Mdg.Engine.Proto.Trace.Details do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          variables_json: %{String.t() => String.t()},
          variables: %{String.t() => String.t()},
          raw_query: String.t(),
          operation_name: String.t()
        }
  defstruct [:variables_json, :variables, :raw_query, :operation_name]

  field(:variables_json, 4,
    repeated: true,
    type: Mdg.Engine.Proto.Trace.Details.VariablesJsonEntry,
    map: true
  )

  field(:variables, 1,
    repeated: true,
    type: Mdg.Engine.Proto.Trace.Details.VariablesEntry,
    map: true
  )

  field(:raw_query, 2, type: :string)
  field(:operation_name, 3, type: :string)
end

defmodule Mdg.Engine.Proto.Trace.Details.VariablesJsonEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Mdg.Engine.Proto.Trace.Details.VariablesEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :bytes)
end

defmodule Mdg.Engine.Proto.Trace.Error do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t(),
          location: [Mdg.Engine.Proto.Trace.Location.t()],
          time_ns: non_neg_integer,
          json: String.t()
        }
  defstruct [:message, :location, :time_ns, :json]

  field(:message, 1, type: :string)
  field(:location, 2, repeated: true, type: Mdg.Engine.Proto.Trace.Location)
  field(:time_ns, 3, type: :uint64)
  field(:json, 4, type: :string)
end

defmodule Mdg.Engine.Proto.Trace.HTTP do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          method: integer,
          host: String.t(),
          path: String.t(),
          request_headers: %{String.t() => Mdg.Engine.Proto.Trace.HTTP.Values.t()},
          response_headers: %{String.t() => Mdg.Engine.Proto.Trace.HTTP.Values.t()},
          status_code: non_neg_integer,
          secure: boolean,
          protocol: String.t()
        }
  defstruct [
    :method,
    :host,
    :path,
    :request_headers,
    :response_headers,
    :status_code,
    :secure,
    :protocol
  ]

  field(:method, 1, type: Mdg.Engine.Proto.Trace.HTTP.Method, enum: true)
  field(:host, 2, type: :string)
  field(:path, 3, type: :string)

  field(:request_headers, 4,
    repeated: true,
    type: Mdg.Engine.Proto.Trace.HTTP.RequestHeadersEntry,
    map: true
  )

  field(:response_headers, 5,
    repeated: true,
    type: Mdg.Engine.Proto.Trace.HTTP.ResponseHeadersEntry,
    map: true
  )

  field(:status_code, 6, type: :uint32)
  field(:secure, 8, type: :bool)
  field(:protocol, 9, type: :string)
end

defmodule Mdg.Engine.Proto.Trace.HTTP.Values do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: [String.t()]
        }
  defstruct [:value]

  field(:value, 1, repeated: true, type: :string)
end

defmodule Mdg.Engine.Proto.Trace.HTTP.RequestHeadersEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.Trace.HTTP.Values.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.Trace.HTTP.Values)
end

defmodule Mdg.Engine.Proto.Trace.HTTP.ResponseHeadersEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.Trace.HTTP.Values.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.Trace.HTTP.Values)
end

defmodule Mdg.Engine.Proto.Trace.HTTP.Method do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:UNKNOWN, 0)
  field(:OPTIONS, 1)
  field(:GET, 2)
  field(:HEAD, 3)
  field(:POST, 4)
  field(:PUT, 5)
  field(:DELETE, 6)
  field(:TRACE, 7)
  field(:CONNECT, 8)
  field(:PATCH, 9)
end

defmodule Mdg.Engine.Proto.Trace.Location do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          line: non_neg_integer,
          column: non_neg_integer
        }
  defstruct [:line, :column]

  field(:line, 1, type: :uint32)
  field(:column, 2, type: :uint32)
end

defmodule Mdg.Engine.Proto.Trace.Node do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: {atom, any},
          type: String.t(),
          parent_type: String.t(),
          cache_policy: Mdg.Engine.Proto.Trace.CachePolicy.t(),
          start_time: non_neg_integer,
          end_time: non_neg_integer,
          error: [Mdg.Engine.Proto.Trace.Error.t()],
          child: [Mdg.Engine.Proto.Trace.Node.t()]
        }
  defstruct [:id, :type, :parent_type, :cache_policy, :start_time, :end_time, :error, :child]

  oneof(:id, 0)
  field(:field_name, 1, type: :string, oneof: 0)
  field(:index, 2, type: :uint32, oneof: 0)
  field(:type, 3, type: :string)
  field(:parent_type, 13, type: :string)
  field(:cache_policy, 5, type: Mdg.Engine.Proto.Trace.CachePolicy)
  field(:start_time, 8, type: :uint64)
  field(:end_time, 9, type: :uint64)
  field(:error, 11, repeated: true, type: Mdg.Engine.Proto.Trace.Error)
  field(:child, 12, repeated: true, type: Mdg.Engine.Proto.Trace.Node)
end

defmodule Mdg.Engine.Proto.ReportHeader do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          service: String.t(),
          hostname: String.t(),
          agent_version: String.t(),
          service_version: String.t(),
          runtime_version: String.t(),
          uname: String.t()
        }
  defstruct [:service, :hostname, :agent_version, :service_version, :runtime_version, :uname]

  field(:service, 3, type: :string)
  field(:hostname, 5, type: :string)
  field(:agent_version, 6, type: :string)
  field(:service_version, 7, type: :string)
  field(:runtime_version, 8, type: :string)
  field(:uname, 9, type: :string)
end

defmodule Mdg.Engine.Proto.PathErrorStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          children: %{String.t() => Mdg.Engine.Proto.PathErrorStats.t()},
          errors_count: non_neg_integer,
          requests_with_errors_count: non_neg_integer
        }
  defstruct [:children, :errors_count, :requests_with_errors_count]

  field(:children, 1,
    repeated: true,
    type: Mdg.Engine.Proto.PathErrorStats.ChildrenEntry,
    map: true
  )

  field(:errors_count, 4, type: :uint64)
  field(:requests_with_errors_count, 5, type: :uint64)
end

defmodule Mdg.Engine.Proto.PathErrorStats.ChildrenEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.PathErrorStats.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.PathErrorStats)
end

defmodule Mdg.Engine.Proto.ClientNameStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          latency_count: [integer],
          requests_count_per_version: %{String.t() => non_neg_integer},
          cache_hits_per_version: %{String.t() => non_neg_integer},
          persisted_query_hits_per_version: %{String.t() => non_neg_integer},
          persisted_query_misses_per_version: %{String.t() => non_neg_integer},
          cache_latency_count: [integer],
          root_error_stats: Mdg.Engine.Proto.PathErrorStats.t(),
          requests_with_errors_count: non_neg_integer,
          public_cache_ttl_count: [integer],
          private_cache_ttl_count: [integer]
        }
  defstruct [
    :latency_count,
    :requests_count_per_version,
    :cache_hits_per_version,
    :persisted_query_hits_per_version,
    :persisted_query_misses_per_version,
    :cache_latency_count,
    :root_error_stats,
    :requests_with_errors_count,
    :public_cache_ttl_count,
    :private_cache_ttl_count
  ]

  field(:latency_count, 1, repeated: true, type: :int64)

  field(:requests_count_per_version, 3,
    repeated: true,
    type: Mdg.Engine.Proto.ClientNameStats.RequestsCountPerVersionEntry,
    map: true
  )

  field(:cache_hits_per_version, 4,
    repeated: true,
    type: Mdg.Engine.Proto.ClientNameStats.CacheHitsPerVersionEntry,
    map: true
  )

  field(:persisted_query_hits_per_version, 10,
    repeated: true,
    type: Mdg.Engine.Proto.ClientNameStats.PersistedQueryHitsPerVersionEntry,
    map: true
  )

  field(:persisted_query_misses_per_version, 11,
    repeated: true,
    type: Mdg.Engine.Proto.ClientNameStats.PersistedQueryMissesPerVersionEntry,
    map: true
  )

  field(:cache_latency_count, 5, repeated: true, type: :int64)
  field(:root_error_stats, 6, type: Mdg.Engine.Proto.PathErrorStats)
  field(:requests_with_errors_count, 7, type: :uint64)
  field(:public_cache_ttl_count, 8, repeated: true, type: :int64)
  field(:private_cache_ttl_count, 9, repeated: true, type: :int64)
end

defmodule Mdg.Engine.Proto.ClientNameStats.RequestsCountPerVersionEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :uint64)
end

defmodule Mdg.Engine.Proto.ClientNameStats.CacheHitsPerVersionEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :uint64)
end

defmodule Mdg.Engine.Proto.ClientNameStats.PersistedQueryHitsPerVersionEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :uint64)
end

defmodule Mdg.Engine.Proto.ClientNameStats.PersistedQueryMissesPerVersionEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: non_neg_integer
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :uint64)
end

defmodule Mdg.Engine.Proto.FieldStat do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          return_type: String.t(),
          errors_count: non_neg_integer,
          count: non_neg_integer,
          requests_with_errors_count: non_neg_integer,
          latency_count: [integer]
        }
  defstruct [
    :name,
    :return_type,
    :errors_count,
    :count,
    :requests_with_errors_count,
    :latency_count
  ]

  field(:name, 2, type: :string)
  field(:return_type, 3, type: :string)
  field(:errors_count, 4, type: :uint64)
  field(:count, 5, type: :uint64)
  field(:requests_with_errors_count, 6, type: :uint64)
  field(:latency_count, 8, repeated: true, type: :int64)
end

defmodule Mdg.Engine.Proto.TypeStat do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          field: [Mdg.Engine.Proto.FieldStat.t()],
          per_field_stat: %{String.t() => Mdg.Engine.Proto.FieldStat.t()}
        }
  defstruct [:name, :field, :per_field_stat]

  field(:name, 1, type: :string)
  field(:field, 2, repeated: true, type: Mdg.Engine.Proto.FieldStat)

  field(:per_field_stat, 3,
    repeated: true,
    type: Mdg.Engine.Proto.TypeStat.PerFieldStatEntry,
    map: true
  )
end

defmodule Mdg.Engine.Proto.TypeStat.PerFieldStatEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.FieldStat.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.FieldStat)
end

defmodule Mdg.Engine.Proto.QueryStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          per_client_name: %{String.t() => Mdg.Engine.Proto.ClientNameStats.t()},
          per_type: [Mdg.Engine.Proto.TypeStat.t()],
          per_type_stat: %{String.t() => Mdg.Engine.Proto.TypeStat.t()}
        }
  defstruct [:per_client_name, :per_type, :per_type_stat]

  field(:per_client_name, 1,
    repeated: true,
    type: Mdg.Engine.Proto.QueryStats.PerClientNameEntry,
    map: true
  )

  field(:per_type, 2, repeated: true, type: Mdg.Engine.Proto.TypeStat)

  field(:per_type_stat, 3,
    repeated: true,
    type: Mdg.Engine.Proto.QueryStats.PerTypeStatEntry,
    map: true
  )
end

defmodule Mdg.Engine.Proto.QueryStats.PerClientNameEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.ClientNameStats.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.ClientNameStats)
end

defmodule Mdg.Engine.Proto.QueryStats.PerTypeStatEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.TypeStat.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.TypeStat)
end

defmodule Mdg.Engine.Proto.TracesReport do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          header: Mdg.Engine.Proto.ReportHeader.t(),
          trace: [Mdg.Engine.Proto.Trace.t()]
        }
  defstruct [:header, :trace]

  field(:header, 1, type: Mdg.Engine.Proto.ReportHeader)
  field(:trace, 2, repeated: true, type: Mdg.Engine.Proto.Trace)
end

defmodule Mdg.Engine.Proto.Field do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          return_type: String.t()
        }
  defstruct [:name, :return_type]

  field(:name, 2, type: :string)
  field(:return_type, 3, type: :string)
end

defmodule Mdg.Engine.Proto.Type do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          field: [Mdg.Engine.Proto.Field.t()]
        }
  defstruct [:name, :field]

  field(:name, 1, type: :string)
  field(:field, 2, repeated: true, type: Mdg.Engine.Proto.Field)
end

defmodule Mdg.Engine.Proto.MemStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          total_bytes: non_neg_integer,
          stack_bytes: non_neg_integer,
          heap_bytes: non_neg_integer,
          heap_released_bytes: non_neg_integer,
          gc_overhead_bytes: non_neg_integer,
          stack_used_bytes: non_neg_integer,
          heap_allocated_bytes: non_neg_integer,
          heap_allocated_objects: non_neg_integer,
          heap_allocated_bytes_delta: non_neg_integer,
          heap_allocated_objects_delta: non_neg_integer,
          heap_freed_objects_delta: non_neg_integer,
          gc_stw_ns_delta: non_neg_integer,
          gc_count_delta: non_neg_integer
        }
  defstruct [
    :total_bytes,
    :stack_bytes,
    :heap_bytes,
    :heap_released_bytes,
    :gc_overhead_bytes,
    :stack_used_bytes,
    :heap_allocated_bytes,
    :heap_allocated_objects,
    :heap_allocated_bytes_delta,
    :heap_allocated_objects_delta,
    :heap_freed_objects_delta,
    :gc_stw_ns_delta,
    :gc_count_delta
  ]

  field(:total_bytes, 1, type: :uint64)
  field(:stack_bytes, 2, type: :uint64)
  field(:heap_bytes, 3, type: :uint64)
  field(:heap_released_bytes, 13, type: :uint64)
  field(:gc_overhead_bytes, 4, type: :uint64)
  field(:stack_used_bytes, 5, type: :uint64)
  field(:heap_allocated_bytes, 6, type: :uint64)
  field(:heap_allocated_objects, 7, type: :uint64)
  field(:heap_allocated_bytes_delta, 8, type: :uint64)
  field(:heap_allocated_objects_delta, 9, type: :uint64)
  field(:heap_freed_objects_delta, 10, type: :uint64)
  field(:gc_stw_ns_delta, 11, type: :uint64)
  field(:gc_count_delta, 12, type: :uint64)
end

defmodule Mdg.Engine.Proto.TimeStats do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          uptime_ns: non_neg_integer,
          real_ns_delta: non_neg_integer,
          user_ns_delta: non_neg_integer,
          sys_ns_delta: non_neg_integer
        }
  defstruct [:uptime_ns, :real_ns_delta, :user_ns_delta, :sys_ns_delta]

  field(:uptime_ns, 1, type: :uint64)
  field(:real_ns_delta, 2, type: :uint64)
  field(:user_ns_delta, 3, type: :uint64)
  field(:sys_ns_delta, 4, type: :uint64)
end

defmodule Mdg.Engine.Proto.StatsReport do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          header: Mdg.Engine.Proto.ReportHeader.t(),
          mem_stats: Mdg.Engine.Proto.MemStats.t(),
          time_stats: Mdg.Engine.Proto.TimeStats.t(),
          start_time: Google.Protobuf.Timestamp.t(),
          end_time: Google.Protobuf.Timestamp.t(),
          realtime_duration: non_neg_integer,
          per_query: %{String.t() => Mdg.Engine.Proto.QueryStats.t()},
          legacy_per_query_implicit_operation_name: %{
            String.t() => Mdg.Engine.Proto.QueryStats.t()
          },
          type: [Mdg.Engine.Proto.Type.t()]
        }
  defstruct [
    :header,
    :mem_stats,
    :time_stats,
    :start_time,
    :end_time,
    :realtime_duration,
    :per_query,
    :legacy_per_query_implicit_operation_name,
    :type
  ]

  field(:header, 1, type: Mdg.Engine.Proto.ReportHeader)
  field(:mem_stats, 2, type: Mdg.Engine.Proto.MemStats)
  field(:time_stats, 3, type: Mdg.Engine.Proto.TimeStats)
  field(:start_time, 8, type: Google.Protobuf.Timestamp)
  field(:end_time, 9, type: Google.Protobuf.Timestamp)
  field(:realtime_duration, 10, type: :uint64)

  field(:per_query, 14,
    repeated: true,
    type: Mdg.Engine.Proto.StatsReport.PerQueryEntry,
    map: true
  )

  field(:legacy_per_query_implicit_operation_name, 12,
    repeated: true,
    type: Mdg.Engine.Proto.StatsReport.LegacyPerQueryImplicitOperationNameEntry,
    map: true
  )

  field(:type, 13, repeated: true, type: Mdg.Engine.Proto.Type)
end

defmodule Mdg.Engine.Proto.StatsReport.PerQueryEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.QueryStats.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.QueryStats)
end

defmodule Mdg.Engine.Proto.StatsReport.LegacyPerQueryImplicitOperationNameEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.QueryStats.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.QueryStats)
end

defmodule Mdg.Engine.Proto.FullTracesReport do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          header: Mdg.Engine.Proto.ReportHeader.t(),
          traces_per_query: %{String.t() => Mdg.Engine.Proto.Traces.t()}
        }
  defstruct [:header, :traces_per_query]

  field(:header, 1, type: Mdg.Engine.Proto.ReportHeader)

  field(:traces_per_query, 5,
    repeated: true,
    type: Mdg.Engine.Proto.FullTracesReport.TracesPerQueryEntry,
    map: true
  )
end

defmodule Mdg.Engine.Proto.FullTracesReport.TracesPerQueryEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Mdg.Engine.Proto.Traces.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Mdg.Engine.Proto.Traces)
end

defmodule Mdg.Engine.Proto.Traces do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          trace: [Mdg.Engine.Proto.Trace.t()]
        }
  defstruct [:trace]

  field(:trace, 1, repeated: true, type: Mdg.Engine.Proto.Trace)
end
