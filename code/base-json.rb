json = '{"obj":{"id":"1340940799","name":"bezeltest"}}'
hash = JSON.parse(json)
# {"obj"=>{"id"=>"1340940799", "name"=>"bezeltest"}
hash["obj"]["id"]
# "1340940799"