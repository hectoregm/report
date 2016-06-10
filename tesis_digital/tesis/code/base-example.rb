class Recommendation < Bezel::Base
  set_c3_type :BuildingEnergyConservationOption
  
  has_one :energyConservationOption, EnergyConservationOption
end

rec = Recommendation.find(1)
rec.totalCost