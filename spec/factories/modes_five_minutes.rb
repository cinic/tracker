FactoryGirl.define do
  factory :modes_five_minute, :class => 'Modes::FiveMinute' do
    time '2015-02-10 22:25:00'
    norm 1
    idle 0
    acl 1
    fail 1
    duration_idle 0.0
    duration_norm 10.0
    duration_acl 8.5
    duration_fail 20.0
    packets nil
    chrono_type 'norm'
  end
end
