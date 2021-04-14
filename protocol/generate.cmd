@echo off

echo Generating Python classes...
protoc --proto_path=. --python_out=../client *.proto

echo Generating Elixir classes...
cd ../server
call mix protox.generate --output-path=./lib/protobufs.ex ../protocol/card.proto ../protocol/deck.proto ../protocol/game.proto ../protocol/user.proto ../protocol/message.proto
cd ../protocol