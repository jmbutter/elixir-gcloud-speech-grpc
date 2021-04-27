defmodule GCloud.SpeechAPI do
  @api_url "speech.googleapis.com"
  @api_port 443
  @token_scope "https://www.googleapis.com/auth/cloud-platform"

  @doc """
  Connects to a Google Cloud Speech-to-Text API
  """
  @spec connect() :: {:ok, GRPC.Channel.t()}
  def connect() do
    cred = GRPC.Credential.new(ssl: [cacerts: :certifi.cacerts()])
    gun_opts = %{http2_opts: %{keepalive: :infinity}}

    with {:ok, channel} <-
           GRPC.Stub.connect(@api_url, @api_port, cred: cred, adapter_opts: gun_opts) do
      {:ok, channel}
    end
  end

  @doc """
  Returns a list of options that need to be passed to a Service Stub when making a gRPC call
  """
  @spec request_opts() :: Keyword.t()
  def request_opts() do
    [
      metadata: metadata(),
      content_type: "application/grpc",
      timeout: :infinity
    ]
  end

  defp metadata do
    api_key = Application.get_env(:google, :api_key)
    %{"x-api-key" => api_key}
  end

  @doc """
  Disconnects from Google Cloud Speech-to-Text API
  """
  @spec disconnect(GRPC.Channel.t()) :: {:ok, GRPC.Channel.t()} | {:error, any()}
  defdelegate disconnect(channel), to: GRPC.Stub
end
