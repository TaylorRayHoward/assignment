class Sorter
  BULKY_VOLUME_THRESHOLD = 1_000_000
  BULKY_DIMENSION_THRESHOLD = 150
  HEAVY_THRESHOLD = 20

  def sort(width:, height:, length:, mass:)
    width = normalize_input!(:width, width)
    height = normalize_input!(:height, height)
    length = normalize_input!(:length, length)
    mass = normalize_input!(:mass, mass)

    is_bulky = is_bulky?(width:, height:, length:)
    is_heavy = is_heavy?(mass:)

    if is_bulky && is_heavy
      "REJECTED"
    elsif is_bulky || is_heavy
      "SPECIAL"
    else
      "STANDARD"
    end
  end

  private

  def is_bulky?(width:, height:, length:)
    bulky_dimension?(width:, height:, length:) || bulky_volume?(width:, height:, length:)
  end

  def is_heavy?(mass:)
    mass >= HEAVY_THRESHOLD
  end

  def bulky_dimension?(width:, height:, length:)
    width >= BULKY_DIMENSION_THRESHOLD || height >= BULKY_DIMENSION_THRESHOLD || length >= BULKY_DIMENSION_THRESHOLD
  end

  def bulky_volume?(width:, height:, length:)
    volume = width * height * length
    volume >= BULKY_VOLUME_THRESHOLD
  end

  def normalize_input!(key, value)
    normalized_value = normalize_number(value)
    return normalized_value if valid_normalized_number?(normalized_value)

    raise ArgumentError, "Invalid numeric inputs: #{key}"
  end

  def normalize_number(value)
    return value if value.is_a?(Numeric)
    return nil unless value.is_a?(String)

    Float(value, exception: false)
  end

  def valid_normalized_number?(value)
    value.is_a?(Numeric) && value.finite? && value >= 0
  end
end
