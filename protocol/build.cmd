@echo off

protoc --proto_path=. --python_out=../client *.proto
protoc -I . --elixir_out=gen_descriptors=true:../server/lib *.proto