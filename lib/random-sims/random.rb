# Module for generating the sims
module Randomiser
  # Do everything
  def self::generate_sims
    define_characteristics
    good_to_go = false
    attempt = 0
    while good_to_go == false
      attempt += 1
      @family = generate_family
      good_to_go = valid_family(@family)
    end
    puts "Successfully generated. #{attempt} attempts."
    @family
  end

  # Generate a bunch of sims
  def self::generate_family
    x = rand(1..6)
    sims = []
    x.times do
      sim = random_sim
      sims << sim
    end
    sims
  end

  # Validate the family
  def self::valid_family(sims)
    age_census = count_ages(sims)
    number_of_dependants = age_census['toddler'] + age_census['child']

    # Age count validations to avoid generational overload
    # No more than 2 toddlers, children or teens each
    return false if age_census['toddler'] > 2
    return false if age_census['child'] > 2
    return false if age_census['teenager'] > 2
    # No more than 3 adults or elders each
    return false if age_census['adult'] > 3
    return false if age_census['elder'] > 3

    # If there are toddlers or children, must be at least one adult
    return false if number_of_dependants > 0 && age_census['adult'] < 1
    true
  end

  # Count all age groups
  def self::count_ages(sims)
    age_count = Hash[@ages.map { |x| [x, 0] }]
    sims.each do |sim|
      key = sim[:age]
      age_count[key] += 1
    end
    age_count
  end

  # Count adults
  def self::count_adults(sims)
    adult_count = 0
    sims.each do |sim|
      adult_count += 1 if sim[:age] == 'adult'
    end
    adult_count
  end

  # Count elders
  def self::count_elders(sims)
    elder_count = 0
    sims.each do |sim|
      elder_count += 1 if sim[:age] == 'elder'
    end
    elder_count
  end

  # Generate individual sim
  def self::random_sim
    age = @ages.sample
    gender = @genders.sample
    aspiration = if age == 'toddler' || age == 'child'
                   '-'
                 else
                   @aspirations.sample
                 end
    starsign = @starsigns.sample
    {
      age: age,
      gender: gender,
      aspiration: aspiration,
      starsign: starsign
    }
  end

  # Define all the possible characteristics
  def self::define_characteristics
    @ages = %w(toddler
               child
               teenager
               adult
               elder)
    @genders = %w(female
                  male)
    @aspirations = %w(fortune
                      logic
                      romance
                      family
                      popularity
                      pleasure)
    @starsigns = %w(aries
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
  end
end
