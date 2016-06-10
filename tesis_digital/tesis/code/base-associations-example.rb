class EnergyConservationOption < Bezel::Base
  c3_cached
  set_c3_include "[this, {productCategory: [id]}, {faqs: [id]}]"

  has_one :productCategory, ProductCategory
  has_many :faqs, RecommendationFAQ
end

eco = EnergyConservationOption.find(10)
eco.productCategory
eco.faqs
