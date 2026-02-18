require "rspec/autorun"
require_relative "main"

RSpec.describe Sorter do
  subject(:sorter) { described_class.new }

  it "returns STANDARD for a standard package" do
    result = sorter.sort(width: 10, height: 10, length: 10, mass: 5)
    expect(result).to eq("STANDARD")
  end

  it "returns SPECIAL when the package is heavy only" do
    result = sorter.sort(width: 10, height: 10, length: 10, mass: 20)
    expect(result).to eq("SPECIAL")
  end

  it "returns SPECIAL when the package is bulky only" do
    result = sorter.sort(width: 150, height: 10, length: 10, mass: 5)
    expect(result).to eq("SPECIAL")
  end

  it "returns REJECTED when the package is heavy and bulky" do
    result = sorter.sort(width: 200, height: 200, length: 200, mass: 25)
    expect(result).to eq("REJECTED")
  end

  it "returns STANDARD when decimals are just below heavy and bulky thresholds" do
    result = sorter.sort(width: 149.999, height: 10.0, length: 10.0, mass: 19.999)
    expect(result).to eq("STANDARD")
  end

  it "returns SPECIAL when mass is a decimal just above the heavy threshold" do
    result = sorter.sort(width: 10.0, height: 10.0, length: 10.0, mass: 20.001)
    expect(result).to eq("SPECIAL")
  end

  it "returns SPECIAL when a decimal dimension is exactly the bulky threshold" do
    result = sorter.sort(width: 150.0, height: 10.0, length: 10.0, mass: 19.5)
    expect(result).to eq("SPECIAL")
  end

  it "returns SPECIAL when decimal volume is exactly the bulky threshold" do
    result = sorter.sort(width: 100.0, height: 100.0, length: 100.0, mass: 19.5)
    expect(result).to eq("SPECIAL")
  end

  it "returns REJECTED when decimal mass and dimension are exactly both thresholds" do
    result = sorter.sort(width: 150.0, height: 20.0, length: 20.0, mass: 20.0)
    expect(result).to eq("REJECTED")
  end

  it "accepts numeric strings and converts them" do
    result = sorter.sort(width: "150", height: "10.0", length: "10", mass: "19.9")
    expect(result).to eq("SPECIAL")
  end

  it "raises an error when a numeric string includes units" do
    expect do
      sorter.sort(width: "150cm", height: nil, length: 10.0, mass: "20kg")
    end.to raise_error(ArgumentError, "Invalid numeric inputs: width")
  end

  it "raises an error when nil is provided for a dimension or mass" do
    expect do
      sorter.sort(width: 150, height: nil, length: 10.0, mass: 20)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: height")
  end

  it "raises an error for NaN string input" do
    expect do
      sorter.sort(width: "NaN", height: 10, length: 10, mass: 10)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: width")
  end

  it "raises an error for Infinity string input" do
    expect do
      sorter.sort(width: 10, height: 10, length: 10, mass: "Infinity")
    end.to raise_error(ArgumentError, "Invalid numeric inputs: mass")
  end

  it "raises an error for direct NaN numeric input" do
    expect do
      sorter.sort(width: Float::NAN, height: 10, length: 10, mass: 10)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: width")
  end

  it "raises an error for direct Infinity numeric input" do
    expect do
      sorter.sort(width: 10, height: 10, length: 10, mass: Float::INFINITY)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: mass")
  end

  it "raises an error for negative dimension" do
    expect do
      sorter.sort(width: -1, height: 10, length: 10, mass: 10)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: width")
  end

  it "raises an error for negative mass" do
    expect do
      sorter.sort(width: 10, height: 10, length: 10, mass: -0.1)
    end.to raise_error(ArgumentError, "Invalid numeric inputs: mass")
  end
end
