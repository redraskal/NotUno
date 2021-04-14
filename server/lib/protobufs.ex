# credo:disable-for-this-file
[
  defmodule(Card.Color) do
    @moduledoc false
    (
      (
        @spec default() :: :NONE
        def(default()) do
          :NONE
        end
      )

      @spec encode(atom) :: integer | atom
      [
        def(encode(:NONE)) do
          0
        end,
        def(encode(:RED)) do
          1
        end,
        def(encode(:YELLOW)) do
          2
        end,
        def(encode(:BLUE)) do
          3
        end,
        def(encode(:GREEN)) do
          4
        end
      ]

      def(encode(x)) do
        x
      end

      @spec decode(integer) :: atom | integer
      [
        def(decode(0)) do
          :NONE
        end,
        def(decode(1)) do
          :RED
        end,
        def(decode(2)) do
          :YELLOW
        end,
        def(decode(3)) do
          :BLUE
        end,
        def(decode(4)) do
          :GREEN
        end
      ]

      def(decode(x)) do
        x
      end

      @spec constants() :: [{integer, atom}]
      def(constants()) do
        [{0, :NONE}, {1, :RED}, {2, :YELLOW}, {3, :BLUE}, {4, :GREEN}]
      end
    )
  end,
  defmodule(Card.Type) do
    @moduledoc false
    (
      (
        @spec default() :: :NUMBERED
        def(default()) do
          :NUMBERED
        end
      )

      @spec encode(atom) :: integer | atom
      [
        def(encode(:NUMBERED)) do
          0
        end,
        def(encode(:CANCEL)) do
          1
        end,
        def(encode(:SKIP)) do
          2
        end,
        def(encode(:REVERSE)) do
          3
        end,
        def(encode(:DRAW)) do
          4
        end,
        def(encode(:WILD)) do
          5
        end
      ]

      def(encode(x)) do
        x
      end

      @spec decode(integer) :: atom | integer
      [
        def(decode(0)) do
          :NUMBERED
        end,
        def(decode(1)) do
          :CANCEL
        end,
        def(decode(2)) do
          :SKIP
        end,
        def(decode(3)) do
          :REVERSE
        end,
        def(decode(4)) do
          :DRAW
        end,
        def(decode(5)) do
          :WILD
        end
      ]

      def(decode(x)) do
        x
      end

      @spec constants() :: [{integer, atom}]
      def(constants()) do
        [{0, :NUMBERED}, {1, :CANCEL}, {2, :SKIP}, {3, :REVERSE}, {4, :DRAW}, {5, :WILD}]
      end
    )
  end,
  defmodule(Game.State) do
    @moduledoc false
    (
      (
        @spec default() :: :LOBBY
        def(default()) do
          :LOBBY
        end
      )

      @spec encode(atom) :: integer | atom
      [
        def(encode(:LOBBY)) do
          0
        end,
        def(encode(:INGAME)) do
          1
        end
      ]

      def(encode(x)) do
        x
      end

      @spec decode(integer) :: atom | integer
      [
        def(decode(0)) do
          :LOBBY
        end,
        def(decode(1)) do
          :INGAME
        end
      ]

      def(decode(x)) do
        x
      end

      @spec constants() :: [{integer, atom}]
      def(constants()) do
        [{0, :LOBBY}, {1, :INGAME}]
      end
    )
  end,
  defmodule(Message.Op) do
    @moduledoc false
    (
      (
        @spec default() :: :UNKNOWN
        def(default()) do
          :UNKNOWN
        end
      )

      @spec encode(atom) :: integer | atom
      [
        def(encode(:UNKNOWN)) do
          0
        end,
        def(encode(:CLIENT_LOGIN)) do
          1
        end,
        def(encode(:SERVER_LOGIN_SUCCESS)) do
          2
        end,
        def(encode(:SERVER_LOGIN_ERROR)) do
          3
        end,
        def(encode(:CLIENT_JOIN_SESSION)) do
          4
        end,
        def(encode(:CLIENT_CREATE_SESSION)) do
          5
        end,
        def(encode(:SERVER_JOIN_SESSION)) do
          6
        end,
        def(encode(:SERVER_HAND_UPDATE)) do
          7
        end,
        def(encode(:SERVER_GAME_UPDATE)) do
          8
        end
      ]

      def(encode(x)) do
        x
      end

      @spec decode(integer) :: atom | integer
      [
        def(decode(0)) do
          :UNKNOWN
        end,
        def(decode(1)) do
          :CLIENT_LOGIN
        end,
        def(decode(2)) do
          :SERVER_LOGIN_SUCCESS
        end,
        def(decode(3)) do
          :SERVER_LOGIN_ERROR
        end,
        def(decode(4)) do
          :CLIENT_JOIN_SESSION
        end,
        def(decode(5)) do
          :CLIENT_CREATE_SESSION
        end,
        def(decode(6)) do
          :SERVER_JOIN_SESSION
        end,
        def(decode(7)) do
          :SERVER_HAND_UPDATE
        end,
        def(decode(8)) do
          :SERVER_GAME_UPDATE
        end
      ]

      def(decode(x)) do
        x
      end

      @spec constants() :: [{integer, atom}]
      def(constants()) do
        [
          {0, :UNKNOWN},
          {1, :CLIENT_LOGIN},
          {2, :SERVER_LOGIN_SUCCESS},
          {3, :SERVER_LOGIN_ERROR},
          {4, :CLIENT_JOIN_SESSION},
          {5, :CLIENT_CREATE_SESSION},
          {6, :SERVER_JOIN_SESSION},
          {7, :SERVER_HAND_UPDATE},
          {8, :SERVER_GAME_UPDATE}
        ]
      end
    )
  end,
  defmodule(Card) do
    @moduledoc false
    (
      defstruct(type: [], _number: nil, _color: nil, __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            []
            |> encode__color(msg)
            |> encode__number(msg)
            |> encode_type(msg)
            |> encode_unknown_fields(msg)
          end
        )

        [
          defp(encode__color(acc, msg)) do
            case(msg._color) do
              nil ->
                acc

              {:color, _field_value} ->
                encode_color(acc, msg)
            end
          end,
          defp(encode__number(acc, msg)) do
            case(msg._number) do
              nil ->
                acc

              {:number, _field_value} ->
                encode_number(acc, msg)
            end
          end
        ]

        [
          defp(encode_type(acc, msg)) do
            case(msg.type) do
              [] ->
                acc

              values ->
                [
                  acc,
                  "\n",
                  (
                    {bytes, len} =
                      Enum.reduce(values, {[], 0}, fn value, {acc, len} ->
                        value_bytes =
                          :binary.list_to_bin([
                            value |> Card.Type.encode() |> Protox.Encode.encode_enum()
                          ])

                        {[acc, value_bytes], len + byte_size(value_bytes)}
                      end)

                    [Protox.Varint.encode(len), bytes]
                  )
                ]
            end
          end,
          defp(encode_number(acc, msg)) do
            {_, field_value} = msg._number
            [acc, <<16>>, Protox.Encode.encode_int32(field_value)]
          end,
          defp(encode_color(acc, msg)) do
            {_, field_value} = msg._color
            [acc, <<24>>, field_value |> Card.Color.encode() |> Protox.Encode.encode_enum()]
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(Card))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_enum([], delimited, Card.Type)
                  field = {:type, msg.type ++ List.wrap(value)}
                  {[field], rest}

                {1, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_enum(bytes, Card.Type)
                  field = {:type, msg.type ++ List.wrap(value)}
                  {[field], rest}

                {2, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_int32([], delimited)
                  field = {:_number, {:number, value}}
                  {[field], rest}

                {2, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_int32(bytes)
                  field = {:_number, {:number, value}}
                  {[field], rest}

                {3, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_enum([], delimited, Card.Color)
                  field = {:_color, {:color, value}}
                  {[field], rest}

                {3, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_enum(bytes, Card.Color)
                  field = {:_color, {:color, value}}
                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{
          1 => {:type, :packed, {:enum, Card.Type}},
          2 => {:number, {:oneof, :_number}, :int32},
          3 => {:color, {:oneof, :_color}, {:enum, Card.Color}}
        }
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{
          color: {3, {:oneof, :_color}, {:enum, Card.Color}},
          number: {2, {:oneof, :_number}, :int32},
          type: {1, :packed, {:enum, Card.Type}}
        }
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:type)) do
          {:error, :no_default_value}
        end,
        def(default(:number)) do
          {:error, :no_default_value}
        end,
        def(default(:color)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end,
  defmodule(Deck) do
    @moduledoc false
    (
      defstruct(cards: [], __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            [] |> encode_cards(msg) |> encode_unknown_fields(msg)
          end
        )

        []

        [
          defp(encode_cards(acc, msg)) do
            case(msg.cards) do
              [] ->
                acc

              values ->
                [
                  acc,
                  Enum.reduce(values, [], fn value, acc ->
                    [acc, "\n", Protox.Encode.encode_message(value)]
                  end)
                ]
            end
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(Deck))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Card.decode!(delimited)
                  field = {:cards, msg.cards ++ List.wrap(value)}
                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{1 => {:cards, :unpacked, {:message, Card}}}
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{cards: {1, :unpacked, {:message, Card}}}
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:cards)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end,
  defmodule(Game) do
    @moduledoc false
    (
      defstruct(_code: nil, users: [], _deck: nil, _state: nil, _turn: nil, __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            []
            |> encode__code(msg)
            |> encode__deck(msg)
            |> encode__state(msg)
            |> encode__turn(msg)
            |> encode_users(msg)
            |> encode_unknown_fields(msg)
          end
        )

        [
          defp(encode__code(acc, msg)) do
            case(msg._code) do
              nil ->
                acc

              {:code, _field_value} ->
                encode_code(acc, msg)
            end
          end,
          defp(encode__deck(acc, msg)) do
            case(msg._deck) do
              nil ->
                acc

              {:deck, _field_value} ->
                encode_deck(acc, msg)
            end
          end,
          defp(encode__state(acc, msg)) do
            case(msg._state) do
              nil ->
                acc

              {:state, _field_value} ->
                encode_state(acc, msg)
            end
          end,
          defp(encode__turn(acc, msg)) do
            case(msg._turn) do
              nil ->
                acc

              {:turn, _field_value} ->
                encode_turn(acc, msg)
            end
          end
        ]

        [
          defp(encode_code(acc, msg)) do
            {_, field_value} = msg._code
            [acc, "\n", Protox.Encode.encode_string(field_value)]
          end,
          defp(encode_users(acc, msg)) do
            case(msg.users) do
              [] ->
                acc

              values ->
                [
                  acc,
                  Enum.reduce(values, [], fn value, acc ->
                    [acc, <<18>>, Protox.Encode.encode_message(value)]
                  end)
                ]
            end
          end,
          defp(encode_deck(acc, msg)) do
            {_, field_value} = msg._deck
            [acc, <<26>>, Protox.Encode.encode_message(field_value)]
          end,
          defp(encode_state(acc, msg)) do
            {_, field_value} = msg._state
            [acc, " ", field_value |> Game.State.encode() |> Protox.Encode.encode_enum()]
          end,
          defp(encode_turn(acc, msg)) do
            {_, field_value} = msg._turn
            [acc, "*", Protox.Encode.encode_message(field_value)]
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(Game))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = delimited
                  field = {:_code, {:code, value}}
                  {[field], rest}

                {2, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = User.decode!(delimited)
                  field = {:users, msg.users ++ List.wrap(value)}
                  {[field], rest}

                {3, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Deck.decode!(delimited)

                  field =
                    case(msg._deck) do
                      {:deck, previous_value} ->
                        {:_deck, {:deck, Protox.Message.merge(previous_value, value)}}

                      _ ->
                        {:_deck, {:deck, value}}
                    end

                  {[field], rest}

                {4, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_enum([], delimited, Game.State)
                  field = {:_state, {:state, value}}
                  {[field], rest}

                {4, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_enum(bytes, Game.State)
                  field = {:_state, {:state, value}}
                  {[field], rest}

                {5, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Game.Turn.decode!(delimited)

                  field =
                    case(msg._turn) do
                      {:turn, previous_value} ->
                        {:_turn, {:turn, Protox.Message.merge(previous_value, value)}}

                      _ ->
                        {:_turn, {:turn, value}}
                    end

                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{
          1 => {:code, {:oneof, :_code}, :string},
          2 => {:users, :unpacked, {:message, User}},
          3 => {:deck, {:oneof, :_deck}, {:message, Deck}},
          4 => {:state, {:oneof, :_state}, {:enum, Game.State}},
          5 => {:turn, {:oneof, :_turn}, {:message, Game.Turn}}
        }
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{
          code: {1, {:oneof, :_code}, :string},
          deck: {3, {:oneof, :_deck}, {:message, Deck}},
          state: {4, {:oneof, :_state}, {:enum, Game.State}},
          turn: {5, {:oneof, :_turn}, {:message, Game.Turn}},
          users: {2, :unpacked, {:message, User}}
        }
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:code)) do
          {:error, :no_default_value}
        end,
        def(default(:users)) do
          {:error, :no_default_value}
        end,
        def(default(:deck)) do
          {:error, :no_default_value}
        end,
        def(default(:state)) do
          {:error, :no_default_value}
        end,
        def(default(:turn)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end,
  defmodule(Game.Turn) do
    @moduledoc false
    (
      defstruct(_index: nil, _reversed: nil, __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            [] |> encode__index(msg) |> encode__reversed(msg) |> encode_unknown_fields(msg)
          end
        )

        [
          defp(encode__index(acc, msg)) do
            case(msg._index) do
              nil ->
                acc

              {:index, _field_value} ->
                encode_index(acc, msg)
            end
          end,
          defp(encode__reversed(acc, msg)) do
            case(msg._reversed) do
              nil ->
                acc

              {:reversed, _field_value} ->
                encode_reversed(acc, msg)
            end
          end
        ]

        [
          defp(encode_index(acc, msg)) do
            {_, field_value} = msg._index
            [acc, "\b", Protox.Encode.encode_int32(field_value)]
          end,
          defp(encode_reversed(acc, msg)) do
            {_, field_value} = msg._reversed
            [acc, <<16>>, Protox.Encode.encode_bool(field_value)]
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(Game.Turn))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_int32([], delimited)
                  field = {:_index, {:index, value}}
                  {[field], rest}

                {1, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_int32(bytes)
                  field = {:_index, {:index, value}}
                  {[field], rest}

                {2, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_bool([], delimited)
                  field = {:_reversed, {:reversed, value}}
                  {[field], rest}

                {2, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_bool(bytes)
                  field = {:_reversed, {:reversed, value}}
                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{1 => {:index, {:oneof, :_index}, :int32}, 2 => {:reversed, {:oneof, :_reversed}, :bool}}
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{index: {1, {:oneof, :_index}, :int32}, reversed: {2, {:oneof, :_reversed}, :bool}}
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:index)) do
          {:error, :no_default_value}
        end,
        def(default(:reversed)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end,
  defmodule(Message) do
    @moduledoc false
    (
      defstruct(_opcode: nil, _data: nil, _message: nil, __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            []
            |> encode__data(msg)
            |> encode__message(msg)
            |> encode__opcode(msg)
            |> encode_unknown_fields(msg)
          end
        )

        [
          defp(encode__data(acc, msg)) do
            case(msg._data) do
              nil ->
                acc

              {:data, _field_value} ->
                encode_data(acc, msg)
            end
          end,
          defp(encode__message(acc, msg)) do
            case(msg._message) do
              nil ->
                acc

              {:message, _field_value} ->
                encode_message(acc, msg)
            end
          end,
          defp(encode__opcode(acc, msg)) do
            case(msg._opcode) do
              nil ->
                acc

              {:opcode, _field_value} ->
                encode_opcode(acc, msg)
            end
          end
        ]

        [
          defp(encode_opcode(acc, msg)) do
            {_, field_value} = msg._opcode
            [acc, "\b", field_value |> Message.Op.encode() |> Protox.Encode.encode_enum()]
          end,
          defp(encode_data(acc, msg)) do
            {_, field_value} = msg._data
            [acc, <<18>>, Protox.Encode.encode_bytes(field_value)]
          end,
          defp(encode_message(acc, msg)) do
            {_, field_value} = msg._message
            [acc, <<26>>, Protox.Encode.encode_string(field_value)]
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(Message))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_enum([], delimited, Message.Op)
                  field = {:_opcode, {:opcode, value}}
                  {[field], rest}

                {1, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_enum(bytes, Message.Op)
                  field = {:_opcode, {:opcode, value}}
                  {[field], rest}

                {2, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = delimited
                  field = {:_data, {:data, value}}
                  {[field], rest}

                {3, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = delimited
                  field = {:_message, {:message, value}}
                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{
          1 => {:opcode, {:oneof, :_opcode}, {:enum, Message.Op}},
          2 => {:data, {:oneof, :_data}, :bytes},
          3 => {:message, {:oneof, :_message}, :string}
        }
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{
          data: {2, {:oneof, :_data}, :bytes},
          message: {3, {:oneof, :_message}, :string},
          opcode: {1, {:oneof, :_opcode}, {:enum, Message.Op}}
        }
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:opcode)) do
          {:error, :no_default_value}
        end,
        def(default(:data)) do
          {:error, :no_default_value}
        end,
        def(default(:message)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end,
  defmodule(User) do
    @moduledoc false
    (
      defstruct(_username: nil, _id: nil, _hand: nil, __uf__: [])

      (
        (
          @spec encode(struct) :: {:ok, iodata} | {:error, any}
          def(encode(msg)) do
            try do
              {:ok, encode!(msg)}
            rescue
              e ->
                {:error, e}
            end
          end

          @spec encode!(struct) :: iodata | no_return
          def(encode!(msg)) do
            []
            |> encode__hand(msg)
            |> encode__id(msg)
            |> encode__username(msg)
            |> encode_unknown_fields(msg)
          end
        )

        [
          defp(encode__hand(acc, msg)) do
            case(msg._hand) do
              nil ->
                acc

              {:hand, _field_value} ->
                encode_hand(acc, msg)
            end
          end,
          defp(encode__id(acc, msg)) do
            case(msg._id) do
              nil ->
                acc

              {:id, _field_value} ->
                encode_id(acc, msg)
            end
          end,
          defp(encode__username(acc, msg)) do
            case(msg._username) do
              nil ->
                acc

              {:username, _field_value} ->
                encode_username(acc, msg)
            end
          end
        ]

        [
          defp(encode_username(acc, msg)) do
            {_, field_value} = msg._username
            [acc, "\n", Protox.Encode.encode_string(field_value)]
          end,
          defp(encode_id(acc, msg)) do
            {_, field_value} = msg._id
            [acc, <<16>>, Protox.Encode.encode_int32(field_value)]
          end,
          defp(encode_hand(acc, msg)) do
            {_, field_value} = msg._hand
            [acc, <<26>>, Protox.Encode.encode_message(field_value)]
          end
        ]

        defp(encode_unknown_fields(acc, msg)) do
          Enum.reduce(msg.__struct__.unknown_fields(msg), acc, fn {tag, wire_type, bytes}, acc ->
            case(wire_type) do
              0 ->
                [acc, Protox.Encode.make_key_bytes(tag, :int32), bytes]

              1 ->
                [acc, Protox.Encode.make_key_bytes(tag, :double), bytes]

              2 ->
                len_bytes = bytes |> byte_size() |> Protox.Varint.encode()
                [acc, Protox.Encode.make_key_bytes(tag, :packed), len_bytes, bytes]

              5 ->
                [acc, Protox.Encode.make_key_bytes(tag, :float), bytes]
            end
          end)
        end
      )

      (
        @spec decode(binary) :: {:ok, struct} | {:error, any}
        def(decode(bytes)) do
          try do
            {:ok, decode!(bytes)}
          rescue
            e ->
              {:error, e}
          end
        end

        (
          @spec decode!(binary) :: struct | no_return
          def(decode!(bytes)) do
            parse_key_value(bytes, struct(User))
          end
        )

        (
          @spec parse_key_value(binary, struct) :: struct
          defp(parse_key_value(<<>>, msg)) do
            msg
          end

          defp(parse_key_value(bytes, msg)) do
            {field, rest} =
              case(Protox.Decode.parse_key(bytes)) do
                {0, _, _} ->
                  raise(%Protox.IllegalTagError{})

                {1, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = delimited
                  field = {:_username, {:username, value}}
                  {[field], rest}

                {2, 2, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Protox.Decode.parse_repeated_int32([], delimited)
                  field = {:_id, {:id, value}}
                  {[field], rest}

                {2, _, bytes} ->
                  {value, rest} = Protox.Decode.parse_int32(bytes)
                  field = {:_id, {:id, value}}
                  {[field], rest}

                {3, _, bytes} ->
                  {len, bytes} = Protox.Varint.decode(bytes)
                  <<delimited::binary-size(len), rest::binary>> = bytes
                  value = Deck.decode!(delimited)

                  field =
                    case(msg._hand) do
                      {:hand, previous_value} ->
                        {:_hand, {:hand, Protox.Message.merge(previous_value, value)}}

                      _ ->
                        {:_hand, {:hand, value}}
                    end

                  {[field], rest}

                {tag, wire_type, rest} ->
                  {value, rest} = Protox.Decode.parse_unknown(tag, wire_type, rest)

                  field =
                    {msg.__struct__.unknown_fields_name,
                     [value | msg.__struct__.unknown_fields(msg)]}

                  {[field], rest}
              end

            msg_updated = struct(msg, field)
            parse_key_value(rest, msg_updated)
          end
        )

        []
      )

      @spec defs() :: %{
              required(non_neg_integer) => {atom, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs()) do
        %{
          1 => {:username, {:oneof, :_username}, :string},
          2 => {:id, {:oneof, :_id}, :int32},
          3 => {:hand, {:oneof, :_hand}, {:message, Deck}}
        }
      end

      @spec defs_by_name() :: %{
              required(atom) => {non_neg_integer, Protox.Types.kind(), Protox.Types.type()}
            }
      def(defs_by_name()) do
        %{
          hand: {3, {:oneof, :_hand}, {:message, Deck}},
          id: {2, {:oneof, :_id}, :int32},
          username: {1, {:oneof, :_username}, :string}
        }
      end

      (
        @spec unknown_fields(struct) :: [{non_neg_integer, Protox.Types.tag(), binary}]
        def(unknown_fields(msg)) do
          msg.__uf__
        end

        @spec unknown_fields_name() :: :__uf__
        def(unknown_fields_name()) do
          :__uf__
        end

        @spec clear_unknown_fields(struct) :: struct
        def(clear_unknown_fields(msg)) do
          struct!(msg, [{unknown_fields_name(), []}])
        end
      )

      @spec required_fields() :: []
      def(required_fields()) do
        []
      end

      @spec syntax() :: atom
      def(syntax()) do
        :proto3
      end

      [
        @spec(default(atom) :: {:ok, boolean | integer | String.t() | float} | {:error, atom}),
        def(default(:username)) do
          {:error, :no_default_value}
        end,
        def(default(:id)) do
          {:error, :no_default_value}
        end,
        def(default(:hand)) do
          {:error, :no_default_value}
        end,
        def(default(_)) do
          {:error, :no_such_field}
        end
      ]
    )
  end
]