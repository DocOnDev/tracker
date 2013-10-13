require 'factory_girl'

FactoryGirl.define do
  factory :story do
    name "Story #1"
    status "unscheduled"
    updated { (Time.now * 1000).to_i }
    type "bug"
    creator "John Doe"
    created { (Time.now * 1000).to_i }
    size "1"
    url "http://localhost:8080/12345"
    owner "Jane Henry"
  end
end