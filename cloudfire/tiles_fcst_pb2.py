# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# NO CHECKED-IN PROTOBUF GENCODE
# source: tiles_fcst.proto
# Protobuf Python Version: 5.28.1
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import runtime_version as _runtime_version
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
_runtime_version.ValidateProtobufRuntimeVersion(
    _runtime_version.Domain.PUBLIC,
    5,
    28,
    1,
    '',
    'tiles_fcst.proto'
)
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x10tiles_fcst.proto\"h\n\x07Request\x12\x0f\n\x07pattern\x18\x01 \x01(\t\x12\x16\n\x0e\x66orecast_cycle\x18\x02 \x01(\t\x12\x0f\n\x07lfmdate\x18\x03 \x01(\t\x12\x0c\n\x04tile\x18\x04 \x01(\t\x12\x15\n\rtransfer_mode\x18\x05 \x01(\t\"\x82\x01\n\x05Reply\x12\r\n\x05wxloc\x18\x01 \x01(\t\x12\x0f\n\x07\x66uelloc\x18\x02 \x01(\t\x12\x0f\n\x07topoloc\x18\x03 \x01(\t\x12\x15\n\rstructdensloc\x18\x04 \x01(\t\x12\x0e\n\x06ignloc\x18\x05 \x01(\t\x12\x0e\n\x06lfmloc\x18\x06 \x01(\t\x12\x11\n\tsnodasloc\x18\x07 \x01(\t2.\n\tRiskTiles\x12!\n\x0bGetTileData\x12\x08.Request\x1a\x06.Reply\"\x00\x62\x06proto3')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'tiles_fcst_pb2', _globals)
if not _descriptor._USE_C_DESCRIPTORS:
  DESCRIPTOR._loaded_options = None
  _globals['_REQUEST']._serialized_start=20
  _globals['_REQUEST']._serialized_end=124
  _globals['_REPLY']._serialized_start=127
  _globals['_REPLY']._serialized_end=257
  _globals['_RISKTILES']._serialized_start=259
  _globals['_RISKTILES']._serialized_end=305
# @@protoc_insertion_point(module_scope)
