require File.expand_path(File.dirname(__FILE__) + '/../../lib/step_collection')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/counting_step')

describe StepCollection do

  before :each do
    @collection = StepCollection.new
  end

  it "should return an empty hash when for an empty group" do
    @collection.steps.should be_empty
  end

  it "should return the current steps in the group" do
    s1 = Step.new(1,/regex 1/)
    s2 = Step.new(2,/regex 2/)
    s3 = Step.new(3,/regex 3/)
    @collection.add_step(s1)
    @collection.add_step(s2)
    @collection.add_step(s3)

    @collection.steps[1].regex.should == s1.regex
    @collection.steps[2].regex.should == s2.regex
    @collection.steps[3].regex.should == s3.regex
  end

  describe "adding a step to the step group" do
    before :each do
      @collection = StepCollection.new
    end

    it "should add new steps" do
      step1 = Step.new(1,/regex/)
      counting_step = mock("counting_step")
      CountingStep.stub!(:new).and_return(counting_step)
      counting_step.should_receive(:count=).with(1)
      @collection.add_step(step1)
      @collection.steps.should ==  {1 => counting_step}

    end

    it "should update the count for an existing step" do

      step1 = Step.new(1,/regex/)
      @collection.add_step(step1)
      @collection.add_step(step1)

      @collection.steps[1].count.should == 2
    end

    it "should update step counts when multiple steps present" do
      step1 = Step.new(1,/regex/)
      @collection.add_step(step1)
      @collection.add_step(step1)

      step2 = Step.new(2,/regex/)
      @collection.add_step(step2)

      step3 = Step.new(3,/regex/)
      @collection.add_step(step3)
      @collection.add_step(step3)
      @collection.add_step(step3)

      @collection.steps[1].count.should == 2
      @collection.steps[2].count.should == 1
      @collection.steps[3].count.should == 3

    end

  end

end