self: system:
builtins.mapAttrs
  (name: value: {
    type = "app";
    program = value;
  })
  {
  }
