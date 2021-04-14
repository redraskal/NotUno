use Mix.Config

config :app, NotUnoServer.SocketHandler,
  port: 3000,
  codec: Riverside.Codec.RawBinary,
  show_debug_logs: true