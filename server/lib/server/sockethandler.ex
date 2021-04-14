defmodule NotUnoServer.SocketHandler do

  use Riverside, otp_app: :app

  @impl Riverside
  def handle_message(msg, session, state) do

    # `msg` is a TEXT or BINARY frame sent by client
    # TODO: deliver_me(msg)

    {:ok, session, state}
  end
end