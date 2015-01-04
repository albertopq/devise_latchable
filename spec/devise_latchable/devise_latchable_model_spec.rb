require 'spec_helper'

class User < ActiveRecord::Base
  devise :latchable
end

class LatchResponse
  attr_accessor :data, :error

  def initialize
    @data = {'accountId' => 'accountId'}
    @error = nil
  end
end

class LatchError
  attr_accessor :code

  def initialize code
    @code = code
  end
end


describe User do

  @token = 'token'

  before(:each) do
    @latchMock = instance_double("Latch")
    allow(@latchMock).to receive(:pair) {@latchResponse}
    allow(@latchMock).to receive(:unpair) {@latchResponse}
    allow(@latchMock).to receive(:status) {@latchResponse}
    User.class_variable_set(:@@latch_api, @latchMock)
    @user = User.create!(:email => "foo@bar.com")
    @latchResponse = LatchResponse.new()
  end

  context "when creating the user" do
    it "is iniatially not paired" do
      expect(@user.paired?).to be(false)
    end
  end

  context "when pairing a user" do
    it "it requests to the latch api with the given token" do
      @user.pair(@token)
      expect(@latchMock).to have_received(:pair).with(@token)
    end

    context "when the request fails" do
      before(:each) do
        @latchResponse.error = LatchError.new('206')
      end

      it "adds an error to the model" do
        expect(@user.errors.empty?).to be(true)
        @user.pair(@token)
        expect(@user.errors.empty?).to be(false)
      end
    end

    context "when the request succeeds" do
      it "doesn't add any error if the request succeeds" do
        expect(@user.errors.empty?).to be(true)
        @user.pair(@token)
        expect(@user.errors.empty?).to be(true)
      end

      it "saves the accountId" do
        @user.pair(@token)
        expect(@user.latch_account_id).to eq(@latchResponse.data['accountId'])
      end

      it "makes the user becomes paired" do
        @user.pair(@token)
        expect(@user.paired?).to be(true)
      end
    end
  end

  context "when unpairing a user" do
    it "requests to the latch api" do
      @user.unpair()
      expect(@latchMock).to have_received(:unpair)
    end

    it "sets the user to no paired" do
      @user.pair(@token)
      expect(@user.paired?).to be(true)
      @user.unpair()
      expect(@user.paired?).to be(false)
    end
  end

  context "when destroying a user" do
    it "unpairs it first" do
      @user.destroy
      expect(@latchMock).to have_received(:unpair)
    end
  end

  context "when checking if latch is unlocked" do
    context "if the user is not paired" do
      it "returns true" do
        expect(@user.latch_unlocked?).to be(true)
      end
    end

    context "if the user is paired" do
      before(:each) do
        @user.pair(@token)
        @latchResponse.data = {'operations' => {'first' => {'status' => 'on'}}}
      end

      it "requests the status to the api" do
        @user.latch_unlocked?
        expect(@latchMock).to have_received(:status).with(@user.latch_account_id)
      end

      context "if the latch is locked" do
        it "returns false" do
          @latchResponse.data['operations']['first']['status'] = 'off'
          expect(@user.latch_unlocked?).to be(false)
        end
      end

      context "if the latch is unlocked" do
        it "returns true" do
          expect(@user.latch_unlocked?).to be(true)
        end
      end
    end
  end
end
