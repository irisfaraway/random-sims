# Module for generating the sims
module Randomiser
  # Do everything
  def self::generate_sims
    family = false
    while family == false
      family = generate_family
    end
    family
  end

  # Generate a bunch of sims
  def self::generate_family
    x = rand(1..6)
    sims = []
    x.times do
      sim = random_sim
      sims << sim
    end
    @adult_count = 0
    sims.each do |sim|
      @adult_count += 1 if sim[:age] == 'adult' || sim[:age] == 'elder'
    end
    @adult_count > 0 ? sims : false
  end

  # Generate individual sim
  def self::random_sim
    age = random_age
    gender = random_gender
    aspiration = if age == 'toddler' || age == 'child'
                   'n/a'
                 else
                   random_aspiration
                 end
    starsign = random_starsign
    {
      age: age,
      gender: gender,
      aspiration: aspiration,
      starsign: starsign
    }
  end

  # Age
  def self::random_age
    ages = %w(toddler
              child
              teenager
              adult
              elder)
    ages.sample
  end

  # Gender
  def self::random_gender
    genders = %w(female
                 male)
    genders.sample
  end

  # Aspiration
  def self::random_aspiration
    aspirations = %w(fortune
                     logic
                     romance
                     family
                     popularity
                     pleasure)
    aspirations.sample
  end

  # Zodiac sign
  def self::random_starsign
    starsigns = %w(aries
                   taurus
                   gemini
                   cancer
                   leo
                   virgo
                   libra
                   scorpio
                   sagittarius
                   capricorn
                   aquarius
                   pisces)
    starsigns.sample
  end
end
