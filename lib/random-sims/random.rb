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
    reorder_sims(@family)
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

  # Reorder the family by age
  def self::reorder_sims(sims)
    sorted_sims = []
    @ages.each do |age|
      sims.each do |sim|
        sorted_sims << sim if sim[:age] == age
      end
    end
    sorted_sims.reverse
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
    chemistry = if age == 'toddler' || age == 'child'
                  ['-', '-', '-']
                else
                  @turns.sample(3)
                end
    {
      age: age,
      gender: gender,
      aspiration: aspiration,
      starsign: starsign,
      turn_on_a: chemistry[0],
      turn_on_b: chemistry[1],
      turn_off: chemistry[2]
    }
  end

  # Validate the family
  def self::valid_family(sims)
    valid_ages(sims) && valid_aspirations(sims) && valid_starsigns(sims)
  end

  # Check if age configuration is OK
  def self::valid_ages(sims)
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

  # Check if aspiration configuration is OK
  def self::valid_aspirations(sims)
    aspiration_census = count_aspirations(sims)

    @aspiration_fail = false
    @aspirations.each do |asp|
      # No more than 2 of each aspiration
      @aspiration_fail = true if aspiration_census[asp] > 2
      # Except pleasure sims. I hate pleasure sims
      @aspiration_fail = true if aspiration_census['pleasure'] > 1
      break if @aspiration_fail
    end
    !@aspiration_fail
  end

  # Check if starsign configuration is OK
  def self::valid_starsigns(sims)
    starsign_census = count_starsigns(sims)

    @starsign_fail = false
    # No duplicate starsigns in a family
    @starsigns.each do |str|
      @starsign_fail = true if starsign_census[str] > 1
      break if @starsign_fail
    end
    !@starsign_fail
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

  # Count all aspirations
  def self::count_aspirations(sims)
    aspiration_count = Hash[@aspirations.map { |x| [x, 0] }]
    sims.each do |sim|
      key = sim[:aspiration]
      aspiration_count[key] += 1 unless key == '-'
    end
    aspiration_count
  end

  # Count all starsigns
  def self::count_starsigns(sims)
    starsign_count = Hash[@starsigns.map { |x| [x, 0] }]
    sims.each do |sim|
      key = sim[:starsign]
      starsign_count[key] += 1
    end
    starsign_count
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
    @turns = %w(black\ hair
                blond\ hair
                brown\ hair
                red\ hair
                grey\ hair
                custom\ hair
                facial\ hair
                swimwear
                underwear
                formal\ wear
                glasses
                hats
                jewelry
                makeup
                full\ face\ makeup
                fat
                fitness
                cologne
                stink
                vampires
                werewolves
                plantsims
                zombies
                robots
                cooking
                cleaning
                creativity
                body
                logic
                charisma
                mechanical
                unemployed
                good\ job)
  end
end
