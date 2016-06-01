require "./spec/spec_helper"

describe Place do
  fixtures :places

  [:address_1, :city, :state, :zipcode, :name, :description, :price].each do |attribute|
    it "validates the presence of #{attribute}", :ch2 => true do
      place = places(:bloc_haus)
      place.send("#{attribute}=", nil)
      place.should_not be_valid
    end
  end
   
  [:zipcode, :price].each do |attribute|
    it "validates the numericality of #{attribute}", :ch2 => true do
      place = places(:bloc_haus)
      place.send("#{attribute}=", "IAmAString")
      place.should_not be_valid
    end
  end                                    
end
