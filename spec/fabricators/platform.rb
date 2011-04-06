Fabricator(:platform, :class_name => FiveMobilePush::Platform) do
  on_init {
    init_with(FiveMobilePush::Platform::ALL, FiveMobilePush::Platform::IPHONE)
  }
end
