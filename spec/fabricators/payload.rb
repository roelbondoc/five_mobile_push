Fabricator(:payload, :class_name => FiveMobilePush::Payload) do
  on_init { init_with('bacon', 'foo' => 'bar') }
end
