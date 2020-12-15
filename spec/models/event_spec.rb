require "rails_helper"

RSpec.describe Event, :type => :model do
  let(:user) { create(:user) }

  it { should belong_to(:user) }
  it { should define_enum_for(:status).with_values([:draft, :published]) }
  context "validations" do
    context "if status changed to published" do
      before { allow(subject).to receive(:status_changed?).and_return(true) }
      before { allow(subject).to receive(:published?).and_return(true) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:location) }
    end

    context "if status not changed" do
      before { allow(subject).to receive(:status_changed?).and_return(false) }
      it { should_not validate_presence_of(:name) }
      it { should_not validate_presence_of(:description) }
      it { should_not validate_presence_of(:location) }
    end

    context "if status is draft" do
      before { allow(subject).to receive(:published?).and_return(false) }
      it { should_not validate_presence_of(:name) }
      it { should_not validate_presence_of(:description) }
      it { should_not validate_presence_of(:location) }
    end


    context "validate running attributes" do
      context "if start_date and end_date are missing" do
        it "should be invalid" do
          event = build(:event, user: user, start_date: nil, end_date: nil)
          expect(event.valid?).to be_falsey
          expect(event.errors.full_messages).to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end

      context "if start_date and duration are missing" do
        it "should be invalid" do
          event = build(:event, user: user, start_date: nil, duration: nil)
          expect(event.valid?).to be_falsey
          expect(event.errors.full_messages).to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end

      context "if duration and end_date are missing" do
        it "should be invalid" do
          event = build(:event, user: user, duration: nil, end_date: nil)
          expect(event.valid?).to be_falsey
          expect(event.errors.full_messages).to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end

      context "if start_date is missing" do
        it "should be valid" do
          event = build(:event, user: user, start_date: nil)
          expect(event.valid?).to be_truthy
          expect(event.errors.full_messages).not_to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end

      context "if duration is missing" do
        it "should be valid" do
          event = build(:event, user: user, duration: nil)
          expect(event.valid?).to be_truthy
          expect(event.errors.full_messages).not_to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end

      context "if end_date is missing" do
        it "should be valid" do
          event = build(:event, user: user, end_date: nil)
          expect(event.valid?).to be_truthy
          expect(event.errors.full_messages).not_to include("At least 2 values are mandatory for start_date, end_date and duration.")
        end
      end
    end
  end

  context "callbacks" do
    context ".set_missing_running_attribute" do
      context "if start_date is missing" do
        it "should set the calculated value to start_date" do
          event = build(:event, user: user, start_date: nil)
          expect(event.start_date).to be_blank
          event.save
          event.reload
          expected_start_date = event.end_date - event.duration.days
          expect(event.start_date).to eq(expected_start_date)
        end
      end

      context "if duration is missing" do
        it "should set the calculated value to duration" do
          event = build(:event, user: user, duration: nil)
          expect(event.duration).to be_blank
          event.save
          event.reload
          expected_duration = (event.end_date - event.start_date).to_i + 1
          expect(event.duration).to eq(expected_duration)
        end
      end

      context "if end_date is missing" do
        it "should set the calculated value to start_date" do
          event = build(:event, user: user, end_date: nil)
          expect(event.end_date).to be_blank
          event.save
          event.reload
          expected_end_date = event.start_date + event.duration.days
          expect(event.end_date).to eq(expected_end_date)
        end
      end
    end
  end
  context "soft delete" do
    it "should not delete permanently" do
      event = create(:event, user: user)
      expect(Event.count).to eq(1)
      event.delete
      expect(Event.count).to eq(0)
      expect(Event.with_deleted.count).to eq(1)
    end
  end
end
