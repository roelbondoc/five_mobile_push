Fabricator(:device, :class_name => FiveMobilePush::Device) do
  on_init { init_with(Fabricate.build(:client), '2b6f0cc904d137be2e1730235f5664094b831186') }
end
