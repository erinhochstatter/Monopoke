RSpec.describe Monopoke do
  let(:team_id) { "Rocket" }
  let(:team_id_2) { "Green" }
  let(:team_id_3) { "Orange" }
  let(:monopoke_id) { "Meekachu" }
  let(:monopoke_id_2) { "Rastly" }
  let(:monopoke_id_3) { "Flirtle" }
  let(:hp) { 3 }
  let(:ap) { 1 }
  let(:hp_2) { 5 }
  let(:ap_2) { 6 }
  let(:hp_3) { 4 }
  let(:ap_3) { 3 }

  describe "initialize" do
    it "creates a new Input"
    it "creates a new Battle"
    it "creates an output file"
  end

  describe "start_battle" do
    it "calls each instruction in the input file as a method on the battle"
  end

  describe "create_output_file" do
    it "creates a new file at the existing path"
    it "creates a new file using the current time"
  end

  describe "path_without_input_name" do
    it "removes the file name from the input file path"
  end

  describe "handle_output" do
    it "appends the message to the output file"
    it "puts the message to the console"
  end
end
